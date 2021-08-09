//
//  VodaAudioPlayer.swift
//  VODA_iOS
//
//  Created by 전소영 on 2021/07/25.
//

import Foundation
import AVFoundation

enum AudioPlayerStatus: String {
    case idle
    case prepared
    case playing
    case paused
    case stopped
    case errorOccured
}

enum AudioPlayerError: Error {
    case AudioFileError
    case AudioEngineError
    case AudioManualRenderingModeError
    case AudioPlayerError
    
    var message: String {
        switch self {
        case .AudioFileError:
            return "Audio File Error"
        case .AudioEngineError:
            return "Audio Engine Error"
        case .AudioManualRenderingModeError:
            return "Audio Manual Rendering Mode Error"
        case .AudioPlayerError:
            return "Audio Player Error"
        }
    }
}

protocol AudioPlayable: AnyObject {
    func audioPlayer(_ audioPlayer: VodaAudioPlayer, statusChanged status: AudioPlayerStatus)
    func audioPlayer(_ audioPlayer: VodaAudioPlayer, statusErrorOccured status: AudioPlayerStatus)
    func audioPlayer(_ audioPlayer: VodaAudioPlayer, currentTime: TimeInterval)
}

class VodaAudioPlayer: NSObject {
    private var sourceFile: AVAudioFile?
    private var format: AVAudioFormat?
    private let audioEngine = AVAudioEngine()
    private let audioPlayerNode = AVAudioPlayerNode()
    private let timePitchNode = AVAudioUnitTimePitch()
    private var audioPlayerNodeTimer: Timer?
    private var currentAudioFramePosition: AVAudioFramePosition = 0
    private var totalAudioFrameLength: AVAudioFramePosition = 0
    
    public weak var delegate: AudioPlayable?
    public static let shared = VodaAudioPlayer()
    
    public var status: AudioPlayerStatus = .idle {
        didSet {
            delegate?.audioPlayer(self, statusChanged: status)
        }
    }
    
    public var duration: TimeInterval {
        TimeInterval(totalAudioFrameLength / 44100)
    }
    
    public var currentTime: TimeInterval {
        TimeInterval(currentAudioFramePosition / 44100)
    }
    
    public var pitch: Float {
        get {
            timePitchNode.pitch
        }
        set {
            timePitchNode.pitch = newValue
        }
    }
    
    public var pitchEnabled: Bool {
        get {
            timePitchNode.bypass == false
        }
        set {
            timePitchNode.bypass = !newValue
        }
    }
    
    private override init() {
        super.init()
        setupEngine()
        pitchEnabled = false
    }
}

//MARK: private
private extension VodaAudioPlayer {
    func setupEngine() {
        audioEngine.attach(audioPlayerNode)
        audioEngine.attach(timePitchNode)
        
        let nodes: [AVAudioNode] = [audioPlayerNode, timePitchNode, audioEngine.mainMixerNode]
        for x in 0..<nodes.count - 1 {
            audioEngine.connect(nodes[x], to: nodes[x+1], format: format)
        }
        
        audioEngine.mainMixerNode.installTap(onBus: 0, bufferSize: 4410, format: audioEngine.mainMixerNode.outputFormat(forBus: 0)) { [weak self] buffer, time in
            let convertedCount = Double(buffer.frameLength) * (Double(44100) / buffer.format.sampleRate)
            print("curr__\(convertedCount)__\(buffer.frameLength)__\(UInt32(buffer.format.sampleRate)))")
            self?.currentAudioFramePosition += AVAudioFramePosition(convertedCount)
        }
    }
    
    func prepareAudioFile(with url: URL) {
        sourceFile = try? AVAudioFile(forReading: url)
        format = sourceFile?.processingFormat
        
        guard let sourceFile = sourceFile else {
            return
        }
        
        let convertedFrameLength = Double(sourceFile.length) * (Double(44100) / Double(sourceFile.fileFormat.sampleRate))
        print("total__\(sourceFile.length)__\(sourceFile.fileFormat.sampleRate)__\(convertedFrameLength)")
        totalAudioFrameLength = AVAudioFramePosition(convertedFrameLength)
        
        status = .prepared
    }
    
    func scheduleFile() {
        guard let sourceFile = sourceFile else {
            return
        }
        if status != .stopped {
            stop()
        }
        audioPlayerNode.scheduleFile(sourceFile, at: nil)
    }
    
    func playAudioPlayerNode() {
        do {
            try audioEngine.start()
        } catch {
            print(AudioPlayerError.AudioEngineError.message)
            return
        }
        audioPlayerNode.play()
        status = .playing
    }
    
    @objc func updateAudioPlayerNodeValue() {
        if currentAudioFramePosition >= totalAudioFrameLength {
            stop()
            currentAudioFramePosition = 0
        }
        
        let currentTime = Double(currentAudioFramePosition) / 44100
        delegate?.audioPlayer(self, currentTime: currentTime)
    }
    
    func addAudioPlayerNodeTimer() {
        audioPlayerNodeTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateAudioPlayerNodeValue), userInfo: nil, repeats: true)
    }
    
    func setupAudioManualRenderingMode() {
        do {
            let maxNumberOfFrames: AVAudioFrameCount = 4096
            guard let format = format else {
                return
            }
            try audioEngine.enableManualRenderingMode(.offline, format: format, maximumFrameCount: maxNumberOfFrames)
        } catch {
            print(AudioPlayerError.AudioManualRenderingModeError.message)
            return
        }
    }
    
    func offlineManualRendering() -> URL {
        var outputFile = AVAudioFile()
        
        if let sourceFile = sourceFile {
            do {
                let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
                let outputURL = URL(fileURLWithPath: documentsPath + "/mixLoopProcessed.mp4")
                outputFile = try AVAudioFile(forWriting: outputURL, settings: sourceFile.fileFormat.settings)
            } catch {
                print(AudioPlayerError.AudioFileError.message)
            }
            
            let buffer: AVAudioPCMBuffer = AVAudioPCMBuffer(pcmFormat: audioEngine.manualRenderingFormat, frameCapacity: audioEngine.manualRenderingMaximumFrameCount)!
            
            while audioEngine.manualRenderingSampleTime < sourceFile.length {
                do {
                    let framesToRender = min(buffer.frameCapacity, AVAudioFrameCount(sourceFile.length - audioEngine.manualRenderingSampleTime))
                    let status = try audioEngine.renderOffline(framesToRender, to: buffer)
                    switch status {
                    case .success:
                        // data rendered successfully
                        try outputFile.write(from: buffer)
                        
                    case .insufficientDataFromInputNode:
                        break
                        
                    case .cannotDoInCurrentContext:
                        break
                        
                    case .error:
                        print(AudioPlayerError.AudioManualRenderingModeError.message)
                    }
                } catch {
                    fatalError("\(AudioPlayerError.AudioManualRenderingModeError.message), \(error)")
                }
            }
            audioPlayerNode.stop()
            audioEngine.stop()
        }
        
        print("AVAudioEngine offline rendering completed")
        print("Output \(outputFile.url)")
        
        return outputFile.url
    }
}

//MARK: public
extension VodaAudioPlayer {
    public func play(with url: URL) {
        prepareAudioFile(with: url)
        scheduleFile()
        playAudioPlayerNode()
        addAudioPlayerNodeTimer()
    }
    
    public func resume() {
        status = .playing
        try? audioEngine.start()
        audioPlayerNode.play()
        addAudioPlayerNodeTimer()
    }
    
    public func skipForward(seconds: Double) {
        let seekToTime = currentTime + seconds
        seek(to: seekToTime)
    }
    
    public func skipBackward(seconds: Double) {
        let seekToTime = currentTime + seconds
        seek(to: seekToTime)
    }
    
    public func seek(to time: Double) {
        guard let sourceFile = sourceFile else {
            return
        }
        
        let seekToTime = min(max(0, time), duration)
        currentAudioFramePosition = AVAudioFramePosition(seekToTime * 44100)
        
        let wasPlaying = audioPlayerNode.isPlaying
        audioPlayerNode.stop()
        
        if currentAudioFramePosition < totalAudioFrameLength {
            updateAudioPlayerNodeValue()
            
            let startingFrame = AVAudioFramePosition(seekToTime * sourceFile.fileFormat.sampleRate)
            let frameCount = AVAudioFrameCount(sourceFile.length - startingFrame)
            audioPlayerNode.scheduleSegment(
                sourceFile,
                startingFrame: startingFrame,
                frameCount: frameCount,
                at: nil
            )
            
            if wasPlaying {
                audioPlayerNode.play()
            }
        }
    }
    
    public func pause() {
        status = .paused
        
        audioPlayerNodeTimer?.invalidate()
        audioEngine.pause()
        audioPlayerNode.pause()
    }
    
    public func stop() {
        status = .stopped
        
        audioPlayerNodeTimer?.invalidate()
        
        audioEngine.stop()
        audioEngine.reset()
        
        audioPlayerNode.stop()
        audioPlayerNode.reset()
        currentAudioFramePosition = 0
    }
    
    public func render(with url: URL) -> URL? {
        prepareAudioFile(with: url)
        scheduleFile()
        setupAudioManualRenderingMode()
        playAudioPlayerNode()
        let url = offlineManualRendering()
        audioEngine.disableManualRenderingMode()
        return url
    }
}

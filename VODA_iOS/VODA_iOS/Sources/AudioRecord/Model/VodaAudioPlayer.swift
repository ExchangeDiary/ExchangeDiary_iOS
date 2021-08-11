//
//  VodaAudioPlayer.swift
//  VODA_iOS
//
//  Created by 전소영 on 2021/07/25.
//

import Foundation
import AVFoundation

public protocol AudioPlayable: AnyObject {
    func audioPlayer(_ audioPlayer: VodaAudioPlayer, didChangedStatus status: AudioPlayerStatus)
    func audioPlayer(_ audioPlayer: VodaAudioPlayer, didUpdateCurrentTime currentTime: TimeInterval)
}

public class VodaAudioPlayer: NSObject {
    private var sourceFile: AVAudioFile?
    private var format: AVAudioFormat?
    private let audioEngine = AVAudioEngine()
    private let audioPlayerNode = AVAudioPlayerNode()
    private let timePitchNode = AVAudioUnitTimePitch()
    private var audioPlayerNodeTimer: Timer?
    private var currentAudioFramePosition: AVAudioFramePosition = 0
    private var totalAudioFrameLength: AVAudioFramePosition = 0
    
    public static let shared = VodaAudioPlayer()
    public weak var delegate: AudioPlayable?
    
    public let defaultSampleRate: Double = 44100
    
    public var status: AudioPlayerStatus = .idle {
        didSet {
            delegate?.audioPlayer(self, didChangedStatus: status)
        }
    }
    
    public var duration: TimeInterval {
        TimeInterval(totalAudioFrameLength) / defaultSampleRate
    }
    
    public var currentTime: TimeInterval {
        TimeInterval(currentAudioFramePosition) / defaultSampleRate
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

// MARK: private
private extension VodaAudioPlayer {
    func setupEngine() {
        audioEngine.attach(audioPlayerNode)
        audioEngine.attach(timePitchNode)
        
        let nodes: [AVAudioNode] = [audioPlayerNode, timePitchNode, audioEngine.mainMixerNode]
        for count in 0..<nodes.count - 1 {
            audioEngine.connect(nodes[count], to: nodes[count + 1], format: format)
        }
        
        audioEngine.mainMixerNode.installTap(onBus: 0, bufferSize: AVAudioFrameCount(defaultSampleRate / 10), format: audioEngine.mainMixerNode.outputFormat(forBus: 0)) { [weak self] buffer, _ in
            guard let defaultSampleRate = self?.defaultSampleRate else {
                return
            }
            let convertedCount = Double(buffer.frameLength) * (defaultSampleRate / buffer.format.sampleRate)
            self?.currentAudioFramePosition += AVAudioFramePosition(convertedCount)
        }
    }
    
    func prepareAudioFile(with url: URL) {
        sourceFile = try? AVAudioFile(forReading: url)
        format = sourceFile?.processingFormat
        
        guard let sourceFile = sourceFile else {
            return
        }
        
        let convertedFrameLength = Double(sourceFile.length) * (defaultSampleRate / Double(sourceFile.fileFormat.sampleRate))
        totalAudioFrameLength = AVAudioFramePosition(convertedFrameLength)
        
        status = .prepared
    }
    
    func scheduleFile() {
        guard let sourceFile = sourceFile else {
            return
        }
        audioPlayerNode.scheduleFile(sourceFile, at: nil)
    }
    
    func startEngine() {
        do {
            try audioEngine.start()
        } catch {
            print(AudioPlayerError.audioEngineError.message)
            return
        }
        audioPlayerNode.play()
    }
    
    @objc func updateAudioPlayerNodeValue() {
        let isFinished = currentAudioFramePosition >= totalAudioFrameLength
        if isFinished {
            stop()
        }
        
        let currentTime = Double(currentAudioFramePosition) / defaultSampleRate
        delegate?.audioPlayer(self, didUpdateCurrentTime: currentTime)
    }
    
    func addAudioPlayerNodeTimer() {
        audioPlayerNodeTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateAudioPlayerNodeValue), userInfo: nil, repeats: true)
    }
    
    func enableOfflineRendering() {
        guard let format = format else {
            return
        }
        do {
            let maxNumberOfFrames: AVAudioFrameCount = 4096
            try audioEngine.enableManualRenderingMode(.offline, format: format, maximumFrameCount: maxNumberOfFrames)
        } catch {
            print(AudioPlayerError.audioManualRenderingModeError.message)
            return
        }
        startEngine()
    }
    
    func disableOfflineRendering() {
        audioPlayerNode.stop()
        audioEngine.stop()
        audioEngine.disableManualRenderingMode()
    }
    
    func offlineManualRendering() -> URL? {
        guard let sourceFile = sourceFile else {
            return nil
        }
        guard let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else {
            return nil
        }
        
        var outputFile: AVAudioFile?
        do {
            let outputURL = URL(fileURLWithPath: documentPath + "/mixLoopProcessed.mp4")
            outputFile = try AVAudioFile(forWriting: outputURL, settings: sourceFile.fileFormat.settings)
        } catch {
            print(AudioPlayerError.audioFileError.message)
            return nil
        }
        
        guard let outputFile = outputFile,
              let buffer = AVAudioPCMBuffer(pcmFormat: audioEngine.manualRenderingFormat, frameCapacity: audioEngine.manualRenderingMaximumFrameCount) else {
            return nil
        }
        
        while audioEngine.manualRenderingSampleTime < sourceFile.length {
            do {
                let framesToRender = min(buffer.frameCapacity, AVAudioFrameCount(sourceFile.length - audioEngine.manualRenderingSampleTime))
                let status = try audioEngine.renderOffline(framesToRender, to: buffer)
                switch status {
                case .success:
                    try outputFile.write(from: buffer)
                case .error:
                    print(AudioPlayerError.audioManualRenderingModeError.message)
                    return nil
                default:
                    return nil
                }
            } catch {
                print(AudioPlayerError.audioManualRenderingModeError.message)
                return nil
            }
        }
        print("Output \(outputFile.url)")
        return outputFile.url
    }
}

// MARK: public
extension VodaAudioPlayer {
    public func play(with url: URL) {
        if status != .stopped {
            stop()
        }
        prepareAudioFile(with: url)
        scheduleFile()
        startEngine()
        status = .playing
        addAudioPlayerNodeTimer()
    }
    
    public func resume() {
        try? audioEngine.start()
        audioPlayerNode.play()
        status = .playing
        addAudioPlayerNodeTimer()
    }
    
    public func skipForward(seconds: Double) {
        let seekToTime = currentTime + seconds
        seek(to: seekToTime)
    }
    
    public func skipBackward(seconds: Double) {
        let seekToTime = currentTime - seconds
        seek(to: seekToTime)
    }
    
    public func seek(to time: Double) {
        guard let sourceFile = sourceFile else {
            return
        }
        
        let wasPlaying = audioPlayerNode.isPlaying
        audioPlayerNode.stop()
        
        let seekToTime = min(max(0, time), duration)
        currentAudioFramePosition = AVAudioFramePosition(seekToTime * defaultSampleRate)
        
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
            if !audioEngine.isRunning {
                try? audioEngine.start()
            }
            
            audioPlayerNode.play()
        }
    }
    
    public func pause() {
        audioPlayerNodeTimer?.invalidate()
        audioEngine.pause()
        audioPlayerNode.pause()
        
        status = .paused
    }
    
    public func stop() {
        audioPlayerNodeTimer?.invalidate()
        
        audioEngine.stop()
        audioEngine.reset()
        
        audioPlayerNode.stop()
        audioPlayerNode.reset()
        currentAudioFramePosition = 0
        
        status = .stopped
    }
    
    public func render(with url: URL) -> URL? {
        if status != .stopped {
            stop()
        }
        prepareAudioFile(with: url)
        scheduleFile()

        enableOfflineRendering()
        let url = offlineManualRendering()
        disableOfflineRendering()

        return url
    }
}

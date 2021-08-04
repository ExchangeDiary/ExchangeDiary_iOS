//
//  AudioPlayManager.swift
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

enum AudioPlayerError {
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
    func audioPlayer(_ audioPlayer: AudioPlayManager, statusChanged status: AudioPlayerStatus)
    func audioPlayer(_ audioPlayer: AudioPlayManager, statusErrorOccured status: AudioPlayerStatus)
    func audioPlayer(_ audioPlayer: AudioPlayManager, duration: String)
    func audioPlayer(_ audioPlayer: AudioPlayManager, currentTime: String)
    func audioPlayer(_ audioPlayer: AudioPlayManager, remainingTime: String)
    func audioPlayer(_ audioPlayer: AudioPlayManager, progressValue: Float)
}

class AudioPlayManager: NSObject {
    private var sourceFile: AVAudioFile?
    private var format: AVAudioFormat?
    private var audioPlayer: AVAudioPlayer?
    private var audioEngine = AVAudioEngine()
    private var audioPlayerNode = AVAudioPlayerNode()
    private var audioPlayerTimer: Timer?
    private var audioPlayerNodeTimer: Timer?
    private var audioSampleRate: Double = 0
    private var audioLengthSeconds: Double = 0
    private var seekFrame: AVAudioFramePosition = 0
    private var currentPosition: AVAudioFramePosition = 0
    private var audioLengthSamples: AVAudioFramePosition = 0
    private var status: AudioPlayerStatus = .idle {
        didSet {
            delegate?.audioPlayer(self, statusChanged: status)
        }
    }
    private var isPaused = false
    
    weak var delegate: AudioPlayable?
    static let shared = AudioPlayManager()
    
    private override init() { }
    
    func setUpAudio(audioUrl: URL) {
        do {
            sourceFile = try AVAudioFile(forReading: audioUrl as URL)
            format = sourceFile?.processingFormat
            
            if let sourceFile = sourceFile, let format = format {
                audioLengthSamples = sourceFile.length
                audioSampleRate = format.sampleRate
            }
           
            audioPlayer = try AVAudioPlayer(contentsOf: audioUrl)
            audioPlayer?.prepareToPlay()
            audioPlayer?.delegate = self
            audioPlayer?.isMeteringEnabled = true
            
            status = .prepared
            
            delegate?.audioPlayer(self, duration: audioPlayer?.duration.stringFromTimeInterval() ?? "00 : 00")
        } catch {
            print(AudioPlayerError.AudioFileError.message)
        }
    }
    
    func play(pitch: Float? = nil) {
        status = .playing
        
        if let pitch = pitch {
            if isPaused {
                try? audioEngine.start()
                audioPlayerNode.play()
            } else {
                playWithAudioEffect(pitch: pitch, playOrRender: "play")
            }
            addAudioPlayerNodeTimer()
        } else {
            audioPlayer?.play()
            addAudioPlayerTimer()
        }
        
        isPaused = false
    }
    
    func playWithAudioEffect(pitch: Float, playOrRender: String) {
        audioEngine.stop()
        audioEngine.reset()
        
        audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attach(audioPlayerNode)
        
        let changePitchNode = AVAudioUnitTimePitch()
        changePitchNode.pitch = pitch
        audioEngine.attach(changePitchNode)
        
        connectAudioNodes(audioPlayerNode, changePitchNode, audioEngine.mainMixerNode)
        
        audioPlayerNode.stop()
        guard let sourceFile = sourceFile else {
            return
        }
        
        audioPlayerNode.scheduleFile(sourceFile, at: nil)
        
        if playOrRender == "render" {
            do {
                let maxNumberOfFrames: AVAudioFrameCount = 4096
                guard let format = format else {
                    return
                }
                try audioEngine.enableManualRenderingMode(.offline, format: format, maximumFrameCount: maxNumberOfFrames)
            } catch {
                print(AudioPlayerError.AudioManualRenderingModeError.message)
            }
        }
        
        do {
            try audioEngine.start()
        } catch {
            print(AudioPlayerError.AudioEngineError.message)
            return
        }
        
        audioPlayerNode.play()
    }
    
    func connectAudioNodes(_ nodes: AVAudioNode...) {
        for x in 0..<nodes.count-1 {
            audioEngine.connect(nodes[x], to: nodes[x+1], format: format)
        }
    }
    
    func skipForward(pitch: Float?, seconds: Double) {
        if pitch == nil {
            guard let duration = audioPlayer?.duration else {
                return
            }
            
            guard var audioPlayerCurrentTime = audioPlayer?.currentTime else {
                return
            }
            audioPlayerCurrentTime += 5.0
            
            if audioPlayerCurrentTime < duration {
                audioPlayer?.currentTime = audioPlayerCurrentTime
            } else {
                audioPlayer?.currentTime = duration
            }
            
            updateAudioPlayerValue()
        } else {
            seek(to: seconds)
        }
    }
    
    func skipBackward(pitch: Float?, seconds: Double) {
        if pitch == nil {
            guard var audioPlayerCurrentTime = audioPlayer?.currentTime else {
                return
            }
            audioPlayerCurrentTime -= 5.0
            
            if audioPlayerCurrentTime > 0 {
                audioPlayer?.currentTime = audioPlayerCurrentTime
            } else {
                audioPlayer?.currentTime = 0
            }
            
            updateAudioPlayerValue()
        } else {
            seek(to: seconds)
        }
    }
    
    func seek(to time: Double) {
        guard let sourceFile = sourceFile else {
            return
        }
        
        let offset = AVAudioFramePosition(time * audioSampleRate)
        seekFrame = currentPosition + offset
        seekFrame = max(seekFrame, 0)
        seekFrame = min(seekFrame, audioLengthSamples)
        currentPosition = seekFrame
        
        let wasPlaying = audioPlayerNode.isPlaying
        audioPlayerNode.stop()
        
        if currentPosition < audioLengthSamples {
            updateAudioPlayerNodeValue()
            
            let frameCount = AVAudioFrameCount(audioLengthSamples - seekFrame)
            audioPlayerNode.scheduleSegment(
                sourceFile,
                startingFrame: seekFrame,
                frameCount: frameCount,
                at: nil
            )
            
            if wasPlaying {
                audioPlayerNode.play()
            }
        }
    }
    
    @objc func updateAudioPlayerValue() {
        guard let currentTime = audioPlayer?.currentTime else {
            return
        }
        delegate?.audioPlayer(self, currentTime: currentTime.stringFromTimeInterval())
        
        guard let duration = audioPlayer?.duration else {
            return
        }
        
        guard let remainingTime = audioPlayer?.currentTime.calculateRemaingTime(from: duration).stringFromTimeInterval() else {
            return
        }
        delegate?.audioPlayer(self, remainingTime: remainingTime)
        
        let progressValue = Float(currentTime / duration)
        delegate?.audioPlayer(self, progressValue: progressValue)
    }
    
    @objc func updateAudioPlayerNodeValue() {
        currentPosition = audioPlayerNode.currentFrame + seekFrame
        currentPosition = max(currentPosition, 0)
        currentPosition = min(currentPosition, audioLengthSamples)
        
        if currentPosition >= audioLengthSamples {
            stop()
            seekFrame = 0
            currentPosition = 0
        }
        
        let progressValue = Float(currentPosition) / Float(audioLengthSamples)
        delegate?.audioPlayer(self, progressValue: progressValue)
        
        let playTime = Double(currentPosition) / audioSampleRate
        
        delegate?.audioPlayer(self, currentTime: playTime.stringFromTimeInterval())
        
        audioLengthSeconds = Double(Float(audioLengthSamples) / Float(audioSampleRate))
        let remainingTime = audioLengthSeconds - playTime
        delegate?.audioPlayer(self, remainingTime: remainingTime.stringFromTimeInterval())
    }
    
    func addAudioPlayerTimer() {
        audioPlayerTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateAudioPlayerValue), userInfo: nil, repeats: true)
    }
    
    func addAudioPlayerNodeTimer() {
        audioPlayerNodeTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateAudioPlayerNodeValue), userInfo: nil, repeats: true)
    }
    
    func pause() {
        status = .paused
        
        audioEngine.pause()
        audioPlayerNode.pause()
        audioPlayerNodeTimer?.invalidate()
        
        audioPlayer?.pause()
        audioPlayerTimer?.invalidate()
        
        isPaused = true
    }
    
    func stop() {
        status = .stopped
        
        audioPlayerTimer?.invalidate()
        audioPlayerNodeTimer?.invalidate()
        
        audioEngine.stop()
        audioEngine.reset()
        
        audioPlayerNode.stop()
        
        audioPlayer?.stop()
        audioPlayer?.currentTime = 0
        
        isPaused = false
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

// MARK: AVAudioPlayerDelegate
extension AudioPlayManager: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            stop()
        }
    }
}

extension AVAudioPlayerNode {
    var currentFrame: AVAudioFramePosition {
        guard let lastRenderTime = self.lastRenderTime, let playerTime = self.playerTime(forNodeTime: lastRenderTime) else {
            return 0
        }
        
        return playerTime.sampleTime
    }
}

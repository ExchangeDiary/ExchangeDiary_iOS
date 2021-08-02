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

protocol AudioPlayManagerDelegate: AnyObject {
    func audioPlayer(_ audioPlayer: AudioPlayManager, statusChanged status: AudioPlayerStatus)
    func audioPlayer(_ audioPlayer: AudioPlayManager, statusErrorOccured status: AudioPlayerStatus)
    func audioPlayer(_ audioPlayer: AudioPlayManager, duration: String)
    func audioPlayer(_ audioPlayer: AudioPlayManager, currentTime: String)
    func audioPlayer(_ audioPlayer: AudioPlayManager, remainingTime: String)
}

class AudioPlayManager: NSObject {
    var sourceFile: AVAudioFile?
    var format: AVAudioFormat?
    var audioPlayer: AVAudioPlayer?
    var audioEngine = AVAudioEngine()
    var audioPlayerNode = AVAudioPlayerNode()
    var audioPlayerTimer: Timer?
    var audioPlayerNodeTimer: Timer?
    
    weak var delegate: AudioPlayManagerDelegate?
    static let shared = AudioPlayManager()
    
    var status: AudioPlayerStatus = .idle {
        didSet {
            delegate?.audioPlayer(self, statusChanged: status)
        }
    }
    var paused = false
    
    private override init() { }
    
    func setUpAudio(audioUrl: URL) {
        do {
            // FIXME: engine 생성 확인
            audioEngine = AVAudioEngine()
            
            sourceFile = try AVAudioFile(forReading: audioUrl as URL)
            format = sourceFile?.processingFormat
            
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
            if paused {
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
        paused = false
    }
    
    func playWithAudioEffect(pitch: Float, playOrRender: String) {
        audioEngine.stop()
        audioEngine.reset()
        
        // FIXME: engine, Node 생성 확인
        if playOrRender == "render" {
            audioEngine = AVAudioEngine()
        }
        
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

        audioPlayerNode.scheduleFile(sourceFile, at: nil, completionCallbackType: .dataPlayedBack) { [self] _ in 
            DispatchQueue.main.async {
                stop()
            }
        }
        
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
    
    func skipForward() {
        guard var currentTime = audioPlayer?.currentTime else {
            return
        }
        currentTime += 5.0
        
        guard let duration = audioPlayer?.duration else {
            return
        }
        if currentTime < duration {
            audioPlayer?.currentTime = currentTime
        } else {
            audioPlayer?.currentTime = duration
        }

        audioPlayer?.play(atTime: currentTime)
    }
    
    func skipBackward() {
        guard var currentTime = audioPlayer?.currentTime else {
            return
        }
        currentTime -= 5.0
        
        if currentTime > 0 {
            audioPlayer?.currentTime = currentTime
        } else {
            audioPlayer?.currentTime = 0
        }

        audioPlayer?.play(atTime: currentTime)
    }
    
    @objc func getAudioPlayerCurrentTime() {
        guard let currentTime = audioPlayer?.currentTime.stringFromTimeInterval() else {
            return
        }
        delegate?.audioPlayer(self, currentTime: currentTime)
        
        guard let duration = audioPlayer?.duration else {
            return
        }
    
        guard let remainingTime = audioPlayer?.currentTime.calculateRemaingTime(from: duration).stringFromTimeInterval() else {
            return
        }
        delegate?.audioPlayer(self, remainingTime: remainingTime)
    }
    
    @objc func getAudioPlayerNodeCurrentTime() {
        delegate?.audioPlayer(self, currentTime: audioPlayerNode.currentTime.stringFromTimeInterval())
        
        guard let duration = audioPlayer?.duration else {
            return
        }
    
         let remainingTime = audioPlayerNode.currentTime.calculateRemaingTime(from: duration).stringFromTimeInterval()
        delegate?.audioPlayer(self, remainingTime: remainingTime)
    }
    
    func addAudioPlayerTimer() {
        audioPlayerTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(getAudioPlayerCurrentTime), userInfo: nil, repeats: true)
    }
    
    func addAudioPlayerNodeTimer() {
        audioPlayerNodeTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(getAudioPlayerNodeCurrentTime), userInfo: nil, repeats: true)
    }
    
    func pause() {
        status = .paused
        
        audioEngine.pause()
        audioPlayerNode.pause()
        audioPlayerNodeTimer?.invalidate()
        
        audioPlayer?.pause()
        audioPlayerTimer?.invalidate()
        
        paused = true
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
        
        paused = false
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
    var currentTime: TimeInterval {
        if let nodeTime = lastRenderTime,let playerTime = playerTime(forNodeTime: nodeTime) {
            return Double(playerTime.sampleTime) / playerTime.sampleRate
        }
        return 0
    }
}

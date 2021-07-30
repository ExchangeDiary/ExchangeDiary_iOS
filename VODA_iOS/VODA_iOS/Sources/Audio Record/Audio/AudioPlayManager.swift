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
}

class AudioPlayManager: NSObject {
    var sourceFile: AVAudioFile?
    var format: AVAudioFormat?
    var audioPlayer: AVAudioPlayer?
    var audioEngine = AVAudioEngine()
    var audioPlayerNode = AVAudioPlayerNode()
    
    weak var delegate: AudioPlayManagerDelegate?
    static let shared = AudioPlayManager()
    
    var status: AudioPlayerStatus = .idle {
        didSet {
            delegate?.audioPlayer(self, statusChanged: status)
        }
    }
    var paused = false
    
    private override init() { }
    
    func setupAudio(audioUrl: URL) {
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
        } catch {
            print(AudioPlayerError.AudioFileError.message)
        }
    }
    
    func play(pitch: Float? = nil) {
        status = .playing
        
        if let pitch = pitch {
            if paused {
                do {
                    try? audioEngine.start()
                    audioPlayerNode.play()
                } catch {
                    print("pause play error")
                }
            } else {
                playWithAudioEffect(pitch: pitch, playOrRender: "play")
            }
        } else {
            audioPlayer?.play()
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
    
    func pause() {
        status = .paused
        
        audioEngine.pause()
        audioPlayerNode.pause()
        
        audioPlayer?.pause()
        
        paused = true
    }
    
    func stop() {
        status = .stopped

        audioEngine.stop()
        audioEngine.reset()
        
        audioPlayerNode.stop()
        
        audioPlayer?.stop()
        
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

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
    var recordAudioUrl: URL?
    
    weak var delegate: AudioPlayManagerDelegate?
    static let shared = AudioPlayManager()
    
    var status: AudioPlayerStatus = .idle {
        didSet {
            delegate?.audioPlayer(self, statusChanged: status)
        }
    }
    
    private override init() { }
    
    func setupAudio(recordedAudioUrl: URL) {
        do {
            sourceFile = try AVAudioFile(forReading: recordedAudioUrl as URL)
            recordAudioUrl = recordedAudioUrl
            format = sourceFile?.processingFormat
        } catch {
            print(AudioPlayerError.AudioFileError.message)
        }
    }
    
    func play(pitch: Float? = nil) {
        status = .playing
        
        if let pitch = pitch {
            setAudioEffect(pitch: pitch, isPlaying: true)
        } else {
            do {
                guard let recordedAudioUrl = recordAudioUrl else {
                    return
                }
                audioPlayer = try AVAudioPlayer(contentsOf: recordedAudioUrl)
            } catch {
                print(AudioPlayerError.AudioPlayerError.message)
            }
            
            audioPlayer?.play()
        }
    }
    
    func setAudioEffect(pitch: Float, isPlaying: Bool) {
        audioEngine = AVAudioEngine()
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
        
        if !isPlaying {
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
        audioPlayer?.pause()
    }
    
    func stop() {
        status = .stopped
        
        audioPlayerNode.stop()
        
        audioEngine.stop()
        audioEngine.reset()
        
        audioPlayer?.stop()
    }
    
    func offlineManualRendering() {
        let outputFile: AVAudioFile
        guard let sourceFile = sourceFile else {
            return
        }
        
        do {
            let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            let outputURL = URL(fileURLWithPath: documentsPath + "/mixLoopProcessed.mp4")
            outputFile = try AVAudioFile(forWriting: outputURL, settings: sourceFile.fileFormat.settings)
        } catch {
            fatalError("could not open output audio file, \(error)")
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
                    fatalError("render failed")
                }
            } catch {
                fatalError("render failed, \(error)")
            }
        }
        
        audioPlayerNode.stop()
        audioEngine.stop()
        
        print("AVAudioEngine offline rendering completed")
        print("Output \(outputFile.url)")
    }
}

extension AudioPlayManager: AVAudioPlayerDelegate {
    
}

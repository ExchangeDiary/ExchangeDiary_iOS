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
    
    var message: String {
        switch self {
        case .AudioFileError:
            return "Audio File Error"
        case .AudioEngineError:
            return "Audio Engine Error"
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
    
    private override init() { }
    
    func setupAudio(recordedAudioUrl: URL) {
        do {
            sourceFile = try AVAudioFile(forReading: recordedAudioUrl as URL)
            format = sourceFile?.processingFormat
        } catch {
            print(AudioPlayerError.AudioFileError.message)
        }
    }
    
    func setAudioEffect(pitch: Float) {
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
        
        do {
            try audioEngine.start()
        } catch {
            print(AudioPlayerError.AudioEngineError.message)
            return
        }
    }
    
    func connectAudioNodes(_ nodes: AVAudioNode...) {
        for x in 0..<nodes.count-1 {
            audioEngine.connect(nodes[x], to: nodes[x+1], format: format)
        }
    }
    
    func play(pitch: Float? = nil) {
        status = .playing
        
        if let pitch = pitch {
            setAudioEffect(pitch: pitch)
        }

        audioPlayer?.play()
    }
    
    func pause() {
        status = .paused
        audioPlayer?.pause()
    }
    
    func stop() {
        status = .stopped
        audioPlayer?.stop()
    }
}

extension AudioPlayManager: AVAudioPlayerDelegate {
    
}

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
    
    var message: String {
        switch self {
        case .AudioFileError:
            return "Audio File Error"
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
            print(AudioPlayerError.AudioFileError)
        }
    }
    
    
    
}

extension AudioPlayManager: AVAudioPlayerDelegate {
    
}

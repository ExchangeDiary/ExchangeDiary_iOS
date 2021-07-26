//
//  PlaySoundViewController.swift
//  VODA_iOS
//
//  Created by 전소영 on 2021/07/22.
//

import UIKit

class PlaySoundViewController: UIViewController {
    var recordedAudioUrl: URL?
    var audioPlayer: AudioPlayManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        audioPlayer = AudioPlayManager.shared
        audioPlayer?.delegate = self

        
        guard let recordedUrl = recordedAudioUrl else {
            return
        }
        audioPlayer?.setupAudio(recordedAudioUrl: recordedUrl)
    }
}

// Mark: AudioPlayManagerDelegate
extension PlaySoundViewController: AudioPlayManagerDelegate {
    func audioPlayer(_ audioPlayer: AudioPlayManager, statusChanged status: AudioPlayerStatus) {
        
    }
    
    func audioPlayer(_ audioPlayer: AudioPlayManager, statusErrorOccured status: AudioPlayerStatus) {
        
    }
}

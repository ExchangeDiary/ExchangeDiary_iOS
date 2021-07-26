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
    var pitch: Float?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        audioPlayer = AudioPlayManager.shared
        audioPlayer?.delegate = self
        
        guard let recordedUrl = recordedAudioUrl else {
            return
        }
        audioPlayer?.setupAudio(recordedAudioUrl: recordedUrl)
    }
    
    
    @IBAction func playSound(_ sender: Any) {
        audioPlayer?.play(pitch: pitch)
    }
    
    @IBAction func setHighPitch(_ sender: Any) {
        pitch = 1000
    }
    
    @IBAction func setRowPitch(_ sender: Any) {
        pitch = -800
    }
 
    @IBAction func setNoPitch(_ sender: Any) {
        pitch = nil
    }
    
    @IBAction func sendVoiceFile(_ sender: Any) {
        audioPlayer?.play(pitch: pitch)
        if pitch != nil {
            audioPlayer?.offlineManualRendering()
        }
    }
}

// Mark: AudioPlayManagerDelegate
extension PlaySoundViewController: AudioPlayManagerDelegate {
    func audioPlayer(_ audioPlayer: AudioPlayManager, statusChanged status: AudioPlayerStatus) {
        print("status: \(status)")
    }
    
    func audioPlayer(_ audioPlayer: AudioPlayManager, statusErrorOccured status: AudioPlayerStatus) {
        print("error occured")
    }
}

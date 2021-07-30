//
//  PlaySoundViewController.swift
//  VODA_iOS
//
//  Created by 전소영 on 2021/07/22.
//

import UIKit

class PlaySoundViewController: UIViewController {
    @IBOutlet weak var statusButton: UIButton!
    
    var audioPlayer: AudioPlayManager?
    var recordedAudioUrl: URL?
    var pitch: Float?
    var sendAudioUrl: URL?
    var playStatus: AudioPlayerStatus?
    var isPlaying = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioPlayer = AudioPlayManager.shared
        audioPlayer?.delegate = self
        
        guard let recordedUrl = recordedAudioUrl else {
            return
        }
        audioPlayer?.setupAudio(audioUrl: recordedUrl)
    }
    
    @IBAction func playSound(_ sender: Any) {
        if isPlaying {
            audioPlayer?.pause()
            isPlaying = false
        } else {
            audioPlayer?.play(pitch: pitch)
            isPlaying = true
        }
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
    
    @IBAction func sendAudioData(_ sender: Any) {
        if let pitchValue = pitch {
            audioPlayer?.playWithAudioEffect(pitch: pitchValue, playOrRender: "render")
            sendAudioUrl = audioPlayer?.offlineManualRendering()
        } else {
            sendAudioUrl = recordedAudioUrl
        }
        
        guard let url = sendAudioUrl else {
            return
        }
        print("sendAudioUrl: \(url)")
        
        //FIXME: 추후 서버로 보낼 오디오 데이터
        guard let data = try? Data(contentsOf: url) else {
            return
        }
    }
    
    func changeStatusButtonImage(_ playStatus: AudioPlayerStatus) {
        switch playStatus {
        case .idle, .prepared, .paused, .stopped:
            statusButton.setImage(UIImage(named: "resume"), for: .normal)
        case .playing:
            statusButton.setImage(UIImage(named: "pause"), for: .normal)
        default:
            break
        }
    }
}

// Mark: AudioPlayManagerDelegate
extension PlaySoundViewController: AudioPlayManagerDelegate {
    func audioPlayer(_ audioPlayer: AudioPlayManager, statusChanged status: AudioPlayerStatus) {
        print("play status: \(status)")
        if status == .stopped {
            isPlaying = false
        }
        
        changeStatusButtonImage(status)
    }
    
    func audioPlayer(_ audioPlayer: AudioPlayManager, statusErrorOccured status: AudioPlayerStatus) {
        print("error occured")
    }
}

//
//  PlaySoundViewController.swift
//  VODA_iOS
//
//  Created by 전소영 on 2021/07/22.
//

import UIKit

class PlaySoundViewController: UIViewController {
    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet weak var totalDuration: UILabel!
    @IBOutlet weak var currentPlayingTime: UILabel!
    @IBOutlet weak var remainingPlayingTime: UILabel!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var progressBar: UIView!
    @IBOutlet weak var progressBarWidth: NSLayoutConstraint!
    @IBOutlet weak var seekingPointView: UIView!
    @IBOutlet weak var 버릴progressView: UIProgressView!
    private var audioPlayer: AudioPlayManager?
    private var pitch: Float?
    private var sendAudioUrl: URL?
    private var playStatus: AudioPlayerStatus?
    private var isPlaying = false
    private var playDuration: String? {
        audioPlayer?.getAudioPlayerDuration().stringFromTimeInterval()
    }
    var recordedAudioUrl: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioPlayer = AudioPlayManager.shared
        audioPlayer?.delegate = self
        
        guard let recordedUrl = recordedAudioUrl else {
            return
        }
        audioPlayer?.setUpAudio(audioUrl: recordedUrl)
        
        guard let duration = playDuration else {
            return
        }
        
        remainingPlayingTime.text = "-\(duration)"
        progressView.progress = 0
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
    
    @IBAction func skipBackward(_ sender: Any) {
        audioPlayer?.skipBackward(pitch: pitch, seconds: -5)
    }
    
    @IBAction func skipForward(_ sender: Any) {
        audioPlayer?.skipForward(pitch: pitch, seconds: 5)
    }
    
    @IBAction func setHighPitch(_ sender: Any) {
        pitch = 1000
        audioPlayer?.stop()
    }
    
    @IBAction func setRowPitch(_ sender: Any) {
        pitch = -800
        audioPlayer?.stop()
    }
    
    @IBAction func setNoPitch(_ sender: Any) {
        pitch = nil
        audioPlayer?.stop()
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
}

// Mark: AudioPlayable
extension PlaySoundViewController: AudioPlayable {
    func audioPlayer(_ audioPlayer: AudioPlayManager, statusChanged status: AudioPlayerStatus) {
        print("play status: \(status)")
        guard let duration = playDuration else {
            return
        }
        
        if status == .stopped {
            isPlaying = false
            currentPlayingTime.text = duration
            remainingPlayingTime.text = "-00:00"
        }
        
        changeStatusButtonImage(status)
    }
    
    func audioPlayer(_ audioPlayer: AudioPlayManager, statusErrorOccured status: AudioPlayerStatus) {
        print("error occured")
    }
   
    func audioPlayer(_ audioPlayer: AudioPlayManager, currentTime: String) {
        currentPlayingTime.text = currentTime
    }
    
    func audioPlayer(_ audioPlayer: AudioPlayManager, remainingTime: String) {
        remainingPlayingTime.text = "-\(remainingTime)"
    }
    
    func audioPlayer(_ audioPlayer: AudioPlayManager, progressValue: Float) {
        progressBarWidth.constant = CGFloat(progressValue) * progressView.frame.size.width
    }
}

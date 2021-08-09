//
//  PlaySoundViewController.swift
//  VODA_iOS
//
//  Created by 전소영 on 2021/07/22.
//

import UIKit

class PlaySoundViewController: UIViewController {
    @IBOutlet weak var playStatusButton: UIButton!
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
    private var isPlaying = false
    private var sendAudioUrl: URL?
    private var status: AudioPlayerStatus {
        audioPlayer?.status ?? .idle
    }
    
    var recordedAudioUrl: URL?
    var playDuration: TimeInterval?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioPlayer = AudioPlayManager.shared
        audioPlayer?.delegate = self
        
        audioPlayer?.pitch = 0
        
        guard let duration = playDuration else {
            return
        }
        
        totalDuration.text = duration.stringFromTimeInterval()
        remainingPlayingTime.text = "-\(duration.stringFromTimeInterval())"
        
        progressBarWidth.constant = 0
        addGestureRecognizer()
        
        seekingPointView.layer.borderColor = UIColor.blue.cgColor
        seekingPointView.layer.borderWidth = 3
    }
    
    private func changeStatusButtonImage(_ playStatus: AudioPlayerStatus) {
        switch playStatus {
        case .idle, .prepared, .paused, .stopped:
            playStatusButton.setImage(UIImage(named: "resume"), for: .normal)
        case .playing:
            playStatusButton.setImage(UIImage(named: "pause"), for: .normal)
        default:
            break
        }
    }
    
    private func addGestureRecognizer() {
        //FIXME: 기기에서 세세히 확인하기
        progressView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture)))
        progressBar.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture)))
        seekingPointView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture)))
        
        progressView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapGesture)))
        progressBar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapGesture)))
    }
    
    @objc private func handleTapGesture(sender: UITapGestureRecognizer) {
        let point = sender.location(in: progressView)
        progressBarWidth.constant = point.x
        
        let seekingRate = Double(progressBarWidth.constant / progressView.frame.size.width)
        let seekToTime = (audioPlayer?.duration ?? 0) * seekingRate
        audioPlayer?.seek(to: seekToTime)
    }
    
    @objc private func handlePanGesture(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.view)
        
        progressBarWidth.constant += translation.x
        sender.setTranslation(.zero, in: self.view)
        
        if progressBarWidth.constant > progressView.frame.size.width {
            progressBarWidth.constant = progressView.frame.size.width
        }
        
        let seekingRate = Double(progressBarWidth.constant / progressView.frame.size.width)
        let seekToTime = (audioPlayer?.duration ?? 0) * seekingRate
        audioPlayer?.seek(to: seekToTime)
    }
    
    @IBAction func playSound(_ sender: Any) {
        if isPlaying {
            audioPlayer?.pause()
            isPlaying = false
        } else {
            if status == .paused {
                audioPlayer?.resume()
            } else {
                guard let recordedUrl = recordedAudioUrl else {
                    return
                }
                audioPlayer?.play(with: recordedUrl)
            }
            isPlaying = true
        }
    }
    
    @IBAction func skipBackward(_ sender: Any) {
        audioPlayer?.skipBackward(seconds: -5)
    }
    
    @IBAction func skipForward(_ sender: Any) {
        audioPlayer?.skipForward(seconds: 5)
    }
    
    @IBAction func setHighPitch(_ sender: Any) {
        audioPlayer?.stop()
        audioPlayer?.pitchEnabled = true
        audioPlayer?.pitch = 1000
        progressBarWidth.constant = 0
    }
    
    @IBAction func setRowPitch(_ sender: Any) {
        audioPlayer?.stop()
        audioPlayer?.pitchEnabled = true
        audioPlayer?.pitch = -800
        progressBarWidth.constant = 0
    }
    
    @IBAction func setNoPitch(_ sender: Any) {
        audioPlayer?.stop()
        audioPlayer?.pitchEnabled = false
        progressBarWidth.constant = 0
    }
    
    @IBAction func sendAudioData(_ sender: Any) {
        if audioPlayer?.pitch != 0 {
            guard let recordedUrl = recordedAudioUrl else {
                return
            }
            sendAudioUrl = audioPlayer?.render(with: recordedUrl)
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
            currentPlayingTime.text = duration.stringFromTimeInterval()
            remainingPlayingTime.text = "-00:00"
        }
        
        changeStatusButtonImage(status)
    }
    
    func audioPlayer(_ audioPlayer: AudioPlayManager, statusErrorOccured status: AudioPlayerStatus) {
        print("error occured")
    }
    
    func audioPlayer(_ audioPlayer: AudioPlayManager, currentTime: TimeInterval) {
        currentPlayingTime.text = currentTime.stringFromTimeInterval()
        
        guard let duration = playDuration else {
            return
        }
        let remainingTime = (duration - currentTime).stringFromTimeInterval()
        remainingPlayingTime.text = "-\(remainingTime)"
        progressBarWidth.constant = CGFloat((currentTime / duration)) * progressView.frame.size.width
    }
}

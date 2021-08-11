//
//  PlaySoundViewController.swift
//  VODA_iOS
//
//  Created by 전소영 on 2021/07/22.
//

import UIKit

class PlaySoundViewController: UIViewController {
    @IBOutlet weak var audioTitle: UITextField!
    @IBOutlet weak var playStatusButton: UIButton!
    @IBOutlet weak var totalDuration: UILabel!
    @IBOutlet weak var currentPlayingTime: UILabel!
    @IBOutlet weak var remainingPlayingTime: UILabel!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var progressBar: UIView!
    @IBOutlet weak var progressBarWidth: NSLayoutConstraint!
    @IBOutlet weak var seekingPointView: UIView!
    private var audioPlayer = VodaAudioPlayer.shared
    private var pitch: Float?
    private var isPlaying = false
    private var sendAudioUrl: URL?
    private var status: AudioPlayerStatus {
        audioPlayer.status 
    }
    
    var recordedAudioUrl: URL?
    var playDuration: TimeInterval?
    var recordingTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioPlayer.delegate = self
    
        guard let duration = playDuration else {
            return
        }
        
        totalDuration.text = duration.stringFromTimeInterval()
        remainingPlayingTime.text = "-\(duration.stringFromTimeInterval())"
        
        audioTitle.text = recordingTitle
        
        progressBarWidth.constant = 0
        addGestureRecognizer()
       
        self.setNavigationBarTransparency()
        self.setBackButton(color: .black)
        
        seekingPointView.addBorder(color: UIColor.CustomColor.vodaMainBlue, widhth: 3)
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
        let seekToTime = audioPlayer.duration * seekingRate
        audioPlayer.seek(to: seekToTime)
    }
    
    @objc private func handlePanGesture(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.view)
        
        progressBarWidth.constant += translation.x
        sender.setTranslation(.zero, in: self.view)
        
        if progressBarWidth.constant > progressView.frame.size.width {
            progressBarWidth.constant = progressView.frame.size.width
        }
        
        let seekingRate = Double(progressBarWidth.constant / progressView.frame.size.width)
        let seekToTime = audioPlayer.duration * seekingRate
        audioPlayer.seek(to: seekToTime)
    }
    
    @IBAction func playSound(_ sender: Any) {
        if isPlaying {
            audioPlayer.pause()
            isPlaying = false
        } else {
            if status == .paused {
                audioPlayer.resume()
            } else {
                guard let recordedUrl = recordedAudioUrl else {
                    return
                }
                audioPlayer.play(with: recordedUrl)
            }
            isPlaying = true
        }
    }
    
    @IBAction func skipBackward(_ sender: Any) {
        audioPlayer.skipBackward(seconds: 5)
    }
    
    @IBAction func skipForward(_ sender: Any) {
        audioPlayer.skipForward(seconds: 5)
    }
    
    @IBAction func setHighPitch(_ sender: Any) {
        audioPlayer.stop()
        audioPlayer.pitchEnabled = true
        audioPlayer.pitch = 1000
        progressBarWidth.constant = 0
    }
    
    @IBAction func setRowPitch(_ sender: Any) {
        audioPlayer.stop()
        audioPlayer.pitchEnabled = true
        audioPlayer.pitch = -800
        progressBarWidth.constant = 0
    }
    
    @IBAction func setNoPitch(_ sender: Any) {
        audioPlayer.stop()
        audioPlayer.pitchEnabled = false
        audioPlayer.pitch = 0
        progressBarWidth.constant = 0
    }
    
    @IBAction func sendAudioData(_ sender: Any) {
        if audioPlayer.pitchEnabled {
            guard let recordedUrl = recordedAudioUrl else {
                return
            }
            sendAudioUrl = audioPlayer.render(with: recordedUrl)
        } else {
            sendAudioUrl = recordedAudioUrl
        }
        
        guard let url = sendAudioUrl else {
            return
        }
        print("AVAudioEngine offline rendering completed")
        print("sendAudioUrl: \(url)")
        
        //FIXME: 추후 서버로 보낼 오디오 데이터
        guard let data = try? Data(contentsOf: url) else {
            return
        }
    }
}

// MARK: AudioPlayable
extension PlaySoundViewController: AudioPlayable {
    func audioPlayer(_ audioPlayer: VodaAudioPlayer, didChangedStatus status: AudioPlayerStatus) {
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

    func audioPlayer(_ audioPlayer: VodaAudioPlayer, didUpdateCurrentTime currentTime: TimeInterval) {
        currentPlayingTime.text = currentTime.stringFromTimeInterval()
        
        guard let duration = playDuration else {
            return
        }
        let remainingTime = (duration - currentTime).stringFromTimeInterval()
        remainingPlayingTime.text = "-\(remainingTime)"
        progressBarWidth.constant = CGFloat((currentTime / duration)) * progressView.frame.size.width
    }
}

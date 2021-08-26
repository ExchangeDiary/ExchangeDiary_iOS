//
//  PlaySoundViewController.swift
//  VODA_iOS
//
//  Created by 전소영 on 2021/07/22.
//

import UIKit

class PlaySoundViewController: UIViewController {
    @IBOutlet weak var audioTitleTextField: UITextField!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var totalDurationLabel: UILabel!
    @IBOutlet weak var recordImageView: UIImageView!
    @IBOutlet weak var currentPlayingTimeLabel: UILabel!
    @IBOutlet weak var remainingPlayingTimeLabel: UILabel!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var progressBar: UIView!
    @IBOutlet weak var progressBarWidth: NSLayoutConstraint!
    @IBOutlet weak var seekingPointView: UIView!
    @IBOutlet weak var playStatusButton: UIButton!
    @IBOutlet weak var audioEffectGuideLabel: UILabel!
    @IBOutlet weak var rowPitchButton: UIButton!
    @IBOutlet weak var highPitchButton: UIButton!
    @IBOutlet weak var noPitchButton: UIButton!
    private var audioPlayer = VodaAudioPlayer.shared
    private var pitch: Float?
    private var isReadyToPass = false
    private var isPlaying = false
    private var passAudioUrl: URL?
    private var status: AudioPlayerStatus {
        audioPlayer.status
    }
    
    var recordedAudioUrl: URL?
    var playDuration: TimeInterval?
    var recordingTitle: String?
    var completionHandler: ((AudioData) -> Void)?
    var pageCase: String?
    var audioData: AudioData?
    var storyPreviewSeekingTime: TimeInterval?
    
    private let rightBarButton: UIButton = {
        let rightBarButton = UIButton(frame: CGRect(x: 0, y: 0, width: DeviceInfo.screenWidth * 0.16266, height: DeviceInfo.screenHeight * 0.04802))
        
        rightBarButton.backgroundColor = UIColor.CustomColor.vodaGray4
        rightBarButton.setTitle("완료", for: .normal)
        rightBarButton.titleLabel?.font = UIFont(name: "Apple SD Gothic Neo", size: 14)
        rightBarButton.layer.cornerRadius = 8
        
        return rightBarButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioPlayer.delegate = self
        audioTitleTextField.delegate = self
        
        setUpNavigationBarUI()
        setUpAudioPlayUI()
        
        changeStatusButtonImage(status)
        
        if status == .playing {
            isPlaying = true
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func setUpNavigationBarUI() {
        self.setNavigationBarTransparency()
        self.setBackButton(color: .black)
        
        let rightBarButtonItem = UIBarButtonItem(customView: rightBarButton)
        rightBarButton.addTarget(self, action: #selector(passAudioData(_:)), for: .touchUpInside)
        self.navigationItem.setRightBarButtonItems([rightBarButtonItem], animated: false)
    }
    
    private func setUpAudioPlayUI() {
        if pageCase == "storyPreview" {
            editButton.isHidden = true
            audioEffectGuideLabel.isHidden = true
            rowPitchButton.isHidden = true
            highPitchButton.isHidden = true
            noPitchButton.isHidden = true
            rightBarButton.isHidden = true
            
            switch audioData?.pitch {
            case -800:
                recordImageView.image = UIImage(named: "thickHover")
            case 1000:
                recordImageView.image = UIImage(named: "thinHover")
            default:
                recordImageView.image = UIImage(named: "noEffectHover")
            }
            
            audioTitleTextField.text = audioData?.audioTitle
            
            playDuration = audioPlayer.duration
            
            guard let duration = playDuration else {
                return
            }
            
            guard let seekingTime = storyPreviewSeekingTime else {
                return
            }
            
            if status == .prepared {
                currentPlayingTimeLabel.text = "00:00"
                progressBarWidth.constant = 0
            } else {
                currentPlayingTimeLabel.text = seekingTime.stringFromTimeInterval()
                progressBarWidth.constant = CGFloat((seekingTime / duration)) * progressView.frame.size.width
            }
        } else {
            audioTitleTextField.text = recordingTitle
            
            recordImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(reRecord(_:))))
            
            progressBarWidth.constant = 0
        }
        addGestureRecognizer()
        
        seekingPointView.addBorder(color: UIColor.CustomColor.vodaMainBlue, width: 3)
        
        guard let duration = playDuration else {
            return
        }
        
        totalDurationLabel.text = duration.stringFromTimeInterval()
        remainingPlayingTimeLabel.text = "-\(duration.stringFromTimeInterval())"
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
    
    @objc private func reRecord(_ sender: Any) {
        showButtonPopUp(with: .reRecord, completionHandler: {
            self.navigationController?.popViewController(animated: false)
        })
    }
    
    @IBAction func modifyAudioTitle(_ sender: Any) {
        audioTitleTextField.becomeFirstResponder()
    }
    
    @IBAction func playSound(_ sender: Any) {
        if isPlaying {
            audioPlayer.pause()
            isPlaying = false
        } else {
            if status == .paused {
                audioPlayer.resume()
            } else {
                if pageCase == "storyPreview" {
                    if status == .prepared {
                        audioPlayer.seek(to: 0)
                    } else {
                        audioPlayer.seek(to: storyPreviewSeekingTime ?? 0)
                    }
                    
                    guard let audioUrl = audioData?.audioUrl else {
                        return
                    }
                    
                    guard let playAudioUrl = URL(string: audioUrl) else {
                        return
                    }
                    
                    audioPlayer.play(with: playAudioUrl)
                } else {
                    guard let recordedUrl = recordedAudioUrl else {
                        return
                    }
                    audioPlayer.play(with: recordedUrl)
                }
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
    
    @IBAction func setHighPitch(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        audioPlayer.stop()
        audioPlayer.pitchEnabled = true
        audioPlayer.pitch = 1000
        progressBarWidth.constant = 0
        
        if sender.isSelected {
            rightBarButton.backgroundColor = UIColor.CustomColor.vodaMainBlue
            isReadyToPass = true
            
            rowPitchButton.isSelected = false
            noPitchButton.isSelected = false
        } else {
            rightBarButton.backgroundColor = UIColor.CustomColor.vodaGray4
            audioPlayer.pitchEnabled = false
            isReadyToPass = false
        }
    }
    
    @IBAction func setRowPitch(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        audioPlayer.stop()
        audioPlayer.pitchEnabled = true
        audioPlayer.pitch = -800
        progressBarWidth.constant = 0
        
        if sender.isSelected {
            rightBarButton.backgroundColor = UIColor.CustomColor.vodaMainBlue
            isReadyToPass = true
            
            highPitchButton.isSelected = false
            noPitchButton.isSelected = false
        } else {
            rightBarButton.backgroundColor = UIColor.CustomColor.vodaGray4
            audioPlayer.pitchEnabled = false
            isReadyToPass = false
        }
    }
    
    @IBAction func setNoPitch(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        audioPlayer.stop()
        audioPlayer.pitchEnabled = false
        audioPlayer.pitch = 0
        progressBarWidth.constant = 0
        
        if sender.isSelected {
            rightBarButton.backgroundColor = UIColor.CustomColor.vodaMainBlue
            isReadyToPass = true
            
            highPitchButton.isSelected = false
            rowPitchButton.isSelected = false
        } else {
            rightBarButton.backgroundColor = UIColor.CustomColor.vodaGray4
            audioPlayer.pitchEnabled = false
            isReadyToPass = false
        }
    }
    
    @objc func passAudioData(_ sender: UIButton) {
        if isReadyToPass {
            if audioPlayer.pitchEnabled {
                guard let recordedUrl = recordedAudioUrl else {
                    return
                }
                passAudioUrl = audioPlayer.render(with: recordedUrl)
            } else {
                passAudioUrl = recordedAudioUrl
            }
            
            guard let url = passAudioUrl else {
                return
            }
            print("AVAudioEngine offline rendering completed")
            print("passAudioUrl: \(url)")
            
            if let writeStoryViewController = navigationController?.viewControllers[1] {
                completionHandler?(AudioData(audioTitle: audioTitleTextField.text ?? "", pitch: audioPlayer.pitch, audioUrl: url.absoluteString))
                self.navigationController?.popToViewController(writeStoryViewController, animated: false)
            }
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
            currentPlayingTimeLabel.text = duration.stringFromTimeInterval()
            remainingPlayingTimeLabel.text = "-00:00"
        }
        
        changeStatusButtonImage(status)
    }
    
    func audioPlayer(_ audioPlayer: VodaAudioPlayer, didUpdateCurrentTime currentTime: TimeInterval) {
        currentPlayingTimeLabel.text = currentTime.stringFromTimeInterval()
        storyPreviewSeekingTime = currentTime
        
        guard let duration = playDuration else {
            return
        }
        
        let remainingTime = (duration - currentTime).stringFromTimeInterval()
        remainingPlayingTimeLabel.text = "-\(remainingTime)"
        progressBarWidth.constant = CGFloat((currentTime / duration)) * progressView.frame.size.width
    }
}

// MARK: UITextFieldDelegate
extension PlaySoundViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = audioTitleTextField.text else {
            return false
        }
        
        guard let textRange = Range(range, in: currentText) else {
            return false
        }
        
        let limitedText = currentText.replacingCharacters(in: textRange, with: string)
        
        return limitedText.count <= 15
    }
}

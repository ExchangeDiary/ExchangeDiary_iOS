//
//  StoryDetailViewController.swift
//  VODA_iOS
//
//  Created by 전소영 on 2021/08/22.
//

import UIKit

class StoryDetailViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var storyTempleteImageView: UIImageView!
    @IBOutlet weak var totalView: UIView!
    @IBOutlet weak var totalViewHeight: NSLayoutConstraint!
    @IBOutlet weak var storyWriteDateLabel: UILabel!
    @IBOutlet weak var storyTitleLabel: UILabel!
    @IBOutlet weak var storyLocationLabel: UILabel!
    @IBOutlet weak var storyUserProfileImageView: UIImageView!
    @IBOutlet weak var storyUserNickNameLabel: UILabel!
    @IBOutlet weak var storyTextView: UITextView!
    @IBOutlet weak var storyTextViewHeight: NSLayoutConstraint!
    @IBOutlet weak var storyPhotoImageView: UIImageView!
    @IBOutlet weak var miniAudioPlayerView: UIView!
    @IBOutlet weak var miniAudioPlayerPitchImageView: UIImageView!
    @IBOutlet weak var miniAudioPlayerTitleLabel: UILabel!
    @IBOutlet weak var miniAudioPlayerPlayingTimeLabel: UILabel!
    @IBOutlet weak var miniAudioPlayerPlayImageView: UIImageView!
    private var audioPlayer = VodaAudioPlayer.shared
    private var isPlaying = false
    private var miniAudioPlayerCurrentTime: TimeInterval {
        audioPlayer.currentTime
    }
    private var status: AudioPlayerStatus {
        audioPlayer.status
    }
    var storyData: StoryData?
    var pageCase: String?
    
    private let rightBarButton: UIButton = {
        let rightBarButton = UIButton(frame: CGRect(x: 0, y: 0, width: DeviceInfo.screenWidth * 0.16266, height: DeviceInfo.screenHeight * 0.04802))
        
        rightBarButton.backgroundColor = UIColor.CustomColor.vodaMainBlue
        rightBarButton.setTitle("완료", for: .normal)
        rightBarButton.titleLabel?.font = UIFont(name: "Apple SD Gothic Neo", size: 14)
        rightBarButton.layer.cornerRadius = 8
        
        return rightBarButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioPlayer.delegate = self
        
        setUpNavigationBarUI()
        setUpStoryDataUI()
        setUpAudioUI()
        
        if pageCase == "storyDetail" {
            rightBarButton.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        audioPlayer.delegate = self
        changeAudioPlayStatusButtonImage(status)
        
        if status == .prepared || status == .stopped {
            miniAudioPlayerPlayingTimeLabel.text = "00:00"
        } else {
            miniAudioPlayerPlayingTimeLabel.text = miniAudioPlayerCurrentTime.stringFromTimeInterval()
        }
        
        if status == .playing {
            isPlaying = true
        }
    }
    
    private func setUpNavigationBarUI() {
        self.setNavigationBarTransparency()
        self.setBackButton(color: .black)
        
        let rightBarButtonItem = UIBarButtonItem(customView: rightBarButton)
        //TODO: 서버에 보내기
        //        rightBarButton.addTarget(self, action: #selector(), for: .touchUpInside)
        self.navigationItem.setRightBarButtonItems([rightBarButtonItem], animated: false)
    }
    
    private func setUpStoryDataUI() {
        storyWriteDateLabel.text = storyData?.storyWriteDate
        storyTitleLabel.text = storyData?.storyTitle
        storyLocationLabel.text = storyData?.storyLocation
        //TODO: 서버 연결 후 pageCase에 따라 분기 처리 userImage, nickName
        storyTextView.isEditable = false
        
        guard let storyContentsText = storyData?.storyContentsText else {
            return
        }
        
        storyPhotoImageView.image = storyData?.storyPhotoImage
        
        if storyContentsText == "내용을 적어주세요" || storyContentsText.isEmpty {
            storyTextView.text = ""
            if storyData?.storyPhotoImage == nil {
                storyPhotoImageView.image = UIImage(named: "noStoryText")
            } else {
                storyPhotoImageView.topAnchor.constraint(equalToSystemSpacingBelow: storyTextView.topAnchor, multiplier: 0).isActive = true
            }
        } else {
            storyTextView.text = storyData?.storyContentsText
            storyTextViewHeight.constant = storyTextView.intrinsicContentSize.height
            
            let isOverTotalViewHeight = totalViewHeight.constant < totalViewHeight.constant + storyTextView.intrinsicContentSize.height
            if isOverTotalViewHeight {
                totalViewHeight.constant += ((totalViewHeight.constant + storyTextView.intrinsicContentSize.height) - totalViewHeight.constant)
                
                if storyData?.storyPhotoImage == nil {
                    totalViewHeight.constant -= storyPhotoImageView.bounds.height
                }
                let totalViewMaxY = totalView.bounds.height + totalViewHeight.constant
                let templeteCount = Int(totalViewMaxY / storyTempleteImageView.bounds.maxY)
                
                for count in 0..<templeteCount + 1 {
                    let templeteImageView = UIImageView(frame: CGRect(x: 0, y: storyTempleteImageView.bounds.maxY * CGFloat(count + 1), width: DeviceInfo.screenWidth, height: storyTempleteImageView.bounds.maxY))
                    switch storyData?.storyTemplete {
                    case 1:
                        storyTempleteImageView.image = UIImage(named: "pinkCatTemplete")
                        templeteImageView.image = UIImage(named: "pinkCatTemplete")
                    case 2:
                        storyTempleteImageView.image = UIImage(named: "yellowCatTemplete")
                        templeteImageView.image = UIImage(named: "yellowCatTemplete")
                    default:
                        break
                    }
                    templeteImageView.contentMode = .scaleAspectFill
                    scrollView.addSubview(templeteImageView)
                }
                scrollView.bringSubviewToFront(totalView)
            }
        }

        if storyData?.storyAudioUrl == nil {
            miniAudioPlayerView.isHidden = true
        }
        
        switch storyData?.storyAudioPitch {
        case -800:
            miniAudioPlayerPitchImageView.image = UIImage(named: "thickHover")
        case 1000:
            miniAudioPlayerPitchImageView.image = UIImage(named: "thinHover")
        default:
            miniAudioPlayerPitchImageView.image = UIImage(named: "noEffectHover")
        }
        
        miniAudioPlayerTitleLabel.text = storyData?.storyAudioTitle
    }
    
    private func setUpAudioUI() {
        miniAudioPlayerView.addShadow(width: 0, height: -3, radius: 3, opacity: 0.1)
        miniAudioPlayerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(moveToPlaySoundViewController)))
    }
    
    private func changeAudioPlayStatusButtonImage(_ playStatus: AudioPlayerStatus) {
        switch playStatus {
        case .idle, .prepared, .paused, .stopped:
            miniAudioPlayerPlayImageView.image = UIImage(named: "resume")
        case .playing:
            miniAudioPlayerPlayImageView.image = UIImage(named: "pause")
        default:
            break
        }
    }
    
    @objc private func moveToPlaySoundViewController() {
        let storyboard = UIStoryboard(name: "AudioRecord", bundle: nil)
        guard let playSoundViewController = storyboard.instantiateViewController(identifier: "PlaySoundViewController") as? PlaySoundViewController else {
            return
        }
        
        playSoundViewController.pageCase = "storyPreview"
        playSoundViewController.audioData = AudioData(audioTitle: storyData?.storyAudioTitle, pitch: storyData?.storyAudioPitch, audioUrl: storyData?.storyAudioUrl)
        playSoundViewController.storyPreviewSeekingTime = miniAudioPlayerCurrentTime
        self.navigationController?.pushViewController(playSoundViewController, animated: false)
    }
    
    @IBAction func playSound(_ sender: UIButton) {
        if isPlaying {
            audioPlayer.pause()
            isPlaying = false
        } else {
            if status == .paused {
                audioPlayer.resume()
            } else {
                guard let audioUrl = URL(string: storyData?.storyAudioUrl ?? "") else {
                    return
                }
                audioPlayer.play(with: audioUrl)
            }
            isPlaying = true
        }
    }
}

// MARK: AudioPlayable
extension StoryDetailViewController: AudioPlayable {
    func audioPlayer(_ audioPlayer: VodaAudioPlayer, didChangedStatus status: AudioPlayerStatus) {
        if status == .stopped {
            isPlaying = false
        }
        changeAudioPlayStatusButtonImage(status)
    }
    
    func audioPlayer(_ audioPlayer: VodaAudioPlayer, didUpdateCurrentTime currentTime: TimeInterval) {
        miniAudioPlayerPlayingTimeLabel.text = currentTime.stringFromTimeInterval()
    }
}

// MARK: UIGestureRecognizerDelegate
extension StoryDetailViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let isControllTapped = touch.view is UIControl
        return !isControllTapped
    }
}

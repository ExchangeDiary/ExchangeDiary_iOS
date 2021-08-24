//
//  StoryDetailViewController.swift
//  VODA_iOS
//
//  Created by 전소영 on 2021/08/22.
//

import UIKit

class StoryDetailViewController: UIViewController {
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
    @IBOutlet weak var miniAudioPlayerPlayButton: UIButton!
    
    private var audioPlayer = VodaAudioPlayer.shared
    private var isPlaying = false
    private var status: AudioPlayerStatus {
        audioPlayer.status
    }
    var storyData: StoryData?
    
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
        miniAudioPlayerView.addShadow(width: 0, height: -3, radius: 3, opacity: 0.1)
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
        //TODO: 서버 연결 후 분기 처리 userImage, nickName
        
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
            }
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
    
    private func changeAudioPlayStatusButtonImage(_ playStatus: AudioPlayerStatus) {
        switch playStatus {
        case .idle, .prepared, .paused, .stopped:
            miniAudioPlayerPlayButton.setImage(UIImage(named: "resume"), for: .normal)
        case .playing:
            miniAudioPlayerPlayButton.setImage(UIImage(named: "pause"), for: .normal)
        default:
            break
        }
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

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
    private var fileDownloader = FileDownloader.shared
    private var downloadedAudioUrl: URL?
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
        
        if pageCase == "storyDetail" {
            rightBarButton.isHidden = true
            setUpAudioUrl()
        }
        
        audioPlayer.delegate = self
        
        setUpNavigationBarUI()
        setUpStoryDataUI()
        setUpAudioPlayerUI()
        
        storyUserProfileImageView.addShadow(width: 1, height: 1, radius: 2, opacity: 0.2)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        audioPlayer.delegate = self
        changeAudioPlayStatusButtonImage(status)
        
        if status == .prepared || status == .stopped {
            miniAudioPlayerPlayingTimeLabel.text = "00:00"
        } else {
            miniAudioPlayerPlayingTimeLabel.text = miniAudioPlayerCurrentTime.convertString()
        }
        
        if status == .playing {
            isPlaying = true
        }
    }
    
    private func setUpNavigationBarUI() {
        self.setNavigationBarTransparency()
        self.setBackButton(color: .black)
        
        let rightBarButtonItem = UIBarButtonItem(customView: rightBarButton)
        rightBarButton.addTarget(self, action: #selector(sendStoryData(_:)), for: .touchUpInside)
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
                let templeteMaxSize = 926
                
                for count in 0..<templeteCount + 1 {
                    var templeteMaxY = storyTempleteImageView.bounds.maxY * CGFloat(count + 1)
                    if Int(DeviceInfo.screenHeight) < templeteMaxSize {
                        templeteMaxY -= (CGFloat(templeteMaxSize) - DeviceInfo.screenHeight)
                    }
                    
                    let templeteImageView = UIImageView(frame: CGRect(x: 0, y: templeteMaxY, width: DeviceInfo.screenWidth, height: storyTempleteImageView.bounds.maxY))
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
        case AudioPitch.row:
            miniAudioPlayerPitchImageView.image = UIImage(named: "thickHover")
        case AudioPitch.high:
            miniAudioPlayerPitchImageView.image = UIImage(named: "thinHover")
        default:
            miniAudioPlayerPitchImageView.image = UIImage(named: "noEffectHover")
        }
        
        miniAudioPlayerTitleLabel.text = storyData?.storyAudioTitle
    }
    
    private func setUpAudioPlayerUI() {
        miniAudioPlayerView.addShadow(width: 0, height: -3, radius: 3, opacity: 0.1)
        miniAudioPlayerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(moveToPlaySoundViewController)))
    }
    
    private func setUpAudioUrl() {
        //FIXME: 바로 전 화면에서 서버에서 내려온 audioUrl 전달받아서 변경하기
        if let audioUrl = URL(string: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3") {
            guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                return
            }
            
            let destinationUrl = documentDirectoryUrl.appendingPathComponent(audioUrl.lastPathComponent)
            print("destinationUrl:\(destinationUrl)")
            
            if FileManager.default.fileExists(atPath: destinationUrl.path) {
                print("The file already exists at path")
            } else {
                fileDownloader.downloadFileFromUrl(from: audioUrl, to: destinationUrl)
            }
            downloadedAudioUrl = destinationUrl
        }
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
        let storyboard = UIStoryboard(name: Storyboard.audioRecord.name, bundle: nil)
        guard let playSoundViewController = storyboard.instantiateViewController(identifier: "PlaySoundViewController") as? PlaySoundViewController else {
            return
        }
        
        playSoundViewController.pageCase = "storyPreview"
        
        if pageCase == "storyPreview" {
            playSoundViewController.audioData = AudioData(audioTitle: storyData?.storyAudioTitle, audioFileName: storyData?.storyAudioFileName, pitch: storyData?.storyAudioPitch, audioUrl: storyData?.storyAudioUrl)
        } else {
            playSoundViewController.audioData = AudioData(audioTitle: storyData?.storyAudioTitle, audioFileName: storyData?.storyAudioFileName, pitch: storyData?.storyAudioPitch, audioUrl: downloadedAudioUrl?.absoluteString)
        }
        playSoundViewController.storyPreviewSeekingTime = miniAudioPlayerCurrentTime
        self.navigationController?.pushViewController(playSoundViewController, animated: false)
    }
    
    @objc private func sendStoryData(_ sender: UIButton) {
        //FIXME: 최종 연결 후 index 확인하기
        if let diaryController = navigationController?.viewControllers[1] {
            showButtonPopUp(with: .completeWriteStory, completionHandler: {
                self.audioPlayer.stop()
                self.navigationController?.popToViewController(diaryController, animated: false)
            })
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
                if pageCase == "storyPreview" {
                    if let audioUrl = URL(string: storyData?.storyAudioUrl ?? "") {
                        audioPlayer.play(with: audioUrl)
                    }
                } else {
                    if let playAudioUrl = downloadedAudioUrl {
                        audioPlayer.play(with: playAudioUrl)
//                    FIXME: pitch 받아서
                        audioPlayer.pitch = AudioPitch.zero
                    }
                }
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
        miniAudioPlayerPlayingTimeLabel.text = currentTime.convertString()
    }
}

// MARK: UIGestureRecognizerDelegate
extension StoryDetailViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let isControllTapped = touch.view is UIControl
        return !isControllTapped
    }
}

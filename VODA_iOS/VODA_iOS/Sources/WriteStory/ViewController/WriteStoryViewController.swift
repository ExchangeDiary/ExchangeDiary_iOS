//
//  WriteStoryViewController.swift
//  VODA_iOS
//
//  Created by 전소영 on 2021/08/18.
//

import UIKit

import Moya

class WriteStoryViewController: UIViewController {
    @IBOutlet weak var currentDateLabel: UILabel!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var audioPlayerView: UIView!
    @IBOutlet weak var audioTitleLabelPlaceHolder: UILabel!
    @IBOutlet weak var audioTitleLabel: UILabel!
    @IBOutlet weak var addRecordButton: UIButton!
    @IBOutlet weak var audioPlayingTimeLabel: UILabel!
    @IBOutlet weak var audioPlayButton: UIButton!
    @IBOutlet weak var audioPlayImageVIew: UIImageView!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var contentTextViewHeight: NSLayoutConstraint!
    @IBOutlet weak var totalViewHeight: NSLayoutConstraint!
    @IBOutlet weak var contentTextViewCharacterCountLabel: UILabel!
    @IBOutlet weak var storyPhotoImageView: UIImageView!
    @IBOutlet weak var noSelectTempleteButton: UIButton!
    @IBOutlet weak var catTempleteButton: UIButton!
    @IBOutlet weak var cloudTempleteButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    private var textViewHeight: CGFloat = 0
    private var audioTitle: String?
    private var audioPitch: Float = 0
    private var audioUrl: String?
    private var audioFileName: String?
    private var audioData: Data?
    private var selectedTemplete = 0
    private var audioPlayer = VodaAudioPlayer.shared
    private var isPlaying = false
    private var status: AudioPlayerStatus {
        audioPlayer.status
    }
    
    private let rightBarButton: UIButton = {
        let rightBarButton = UIButton(frame: CGRect(x: 0, y: 0, width: DeviceInfo.screenWidth * 0.16266, height: DeviceInfo.screenHeight * 0.04802))
        
        rightBarButton.backgroundColor = UIColor.CustomColor.vodaGray4
        rightBarButton.setTitle("다음", for: .normal)
        rightBarButton.titleLabel?.font = UIFont(name: "Apple SD Gothic Neo", size: 14)
        rightBarButton.layer.cornerRadius = 8
        
        return rightBarButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.delegate = self
        locationTextField.delegate = self
        titleTextField.delegate = self
        contentTextView.delegate = self
        audioPlayer.delegate = self
        
        currentDateLabel.text = getCurrentDate()
        setContentTextViewPlaceHolder()
        
        textViewHeight = DeviceInfo.screenHeight * 0.32881
        contentTextViewHeight.constant = textViewHeight
        
        setUpNavigationBarUI()
        setUpStoryTemplete()
        setStoryAudioUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        audioPlayer.delegate = self
        audioPlayingTimeLabel.text = "00:00"
        audioPlayer.stop()
        
        (rootViewController as? MainViewController)?.setTabBarHidden(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        audioPlayer.stop()
    }
    
    private func setUpNavigationBarUI() {
        self.setNavigationBarTransparency()
        
        let backButton = UIBarButtonItem(image: UIImage(named: "icBack"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(noSaveStory))
        navigationItem.leftBarButtonItem = backButton
        navigationItem.leftBarButtonItem?.tintColor = .black
        navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
        
        let rightBarButtonItem = UIBarButtonItem(customView: rightBarButton)
        rightBarButton.addTarget(self, action: #selector(passStoryData(_:)), for: .touchUpInside)
        self.navigationItem.setRightBarButtonItems([rightBarButtonItem], animated: false)
    }
    
    private func getCurrentDate(dateUseCase: String? = nil) -> String {
        let nowDate = Date()
        let dateFormatter = DateFormatter()
        
        if dateUseCase == "record" {
            dateFormatter.dateFormat = "yyMMdd"
        } else {
            dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        }
        let currentDate = dateFormatter.string(from: nowDate)
        
        return currentDate
    }
    
    private func setUpStoryTemplete() {
        noSelectTempleteButton.addShadow(width: 2, height: 2, radius: 2, opacity: 0.2)
        catTempleteButton.addShadow(width: 2, height: 2, radius: 2, opacity: 0.2)
        cloudTempleteButton.addShadow(width: 2, height: 2, radius: 2, opacity: 0.2)
        
        noSelectTempleteButton.isSelected = true
    }
    
    private func setStoryAudioUI() {
        audioTitleLabel.isHidden = true
        audioPlayingTimeLabel.isHidden = true
        audioPlayButton.isHidden = true
        audioPlayImageVIew.isHidden = true
    }
    
    private func changeAudioPlayStatusButtonImage(_ playStatus: AudioPlayerStatus) {
        switch playStatus {
        case .idle, .prepared, .paused, .stopped:
            audioPlayImageVIew.image = UIImage(named: "resume")
        case .playing:
            audioPlayImageVIew.image = UIImage(named: "pause")
        default:
            break
        }
    }
    
    private func setRecordButtonImage(pitch: AudioPitch) {
        switch pitch {
        case AudioPitch.zero:
            self.addRecordButton.setImage(UIImage(named: "seletedZeroPitchCat"), for: .normal)
        case AudioPitch.row:
            self.addRecordButton.setImage(UIImage(named: "seletedRowPitchCat"), for: .normal)
        case AudioPitch.high:
            self.addRecordButton.setImage(UIImage(named: "seletedHighPitchCat"), for: .normal)
        }
    }
    
    @objc func noSaveStory() {
        showButtonPopUp(with: .noSaveStory, completionHandler: {
            self.dismiss(animated: false, completion: nil)
            self.navigationController?.popViewController(animated: false)
        })
    }
    
    @objc private func passStoryData(_ sender: UIButton) {
        guard let locationText = locationTextField.text else {
            return
        }
        
        guard let titleText = titleTextField.text else {
            return
        }
        
        if audioUrl == nil, contentTextViewCharacterCountLabel.text == "0/5000자" {
            if locationText.isEmpty || titleText.isEmpty {
                showButtonPopUp(with: .checkStoryLocationTitleNil)
            } else {
                showButtonPopUp(with: .checkStoryContentNil)
            }
        } else if audioTitleLabel.textColor != .black || contentTextViewCharacterCountLabel.text == "0/5000자" {
            if locationText.isEmpty || titleText.isEmpty {
                showButtonPopUp(with: .checkStoryLocationTitleNil)
            }
        }
        
        if rightBarButton.backgroundColor == UIColor.CustomColor.vodaMainBlue {
            guard let storyDetailViewController = self.storyboard?.instantiateViewController(identifier: "StoryDetailViewController") as? StoryDetailViewController else {
                return
            }
            
            if audioTitleLabel.text == "음성으로 기록하기" {
                audioTitle = "Untitle_\(getCurrentDate(dateUseCase: "record"))"
            }

            audioData = FileManager.default.contents(atPath: audioUrl ?? "")
            
            let storyData = StoryData(storyWriteDate: currentDateLabel.text ?? "", storyTitle: titleTextField.text ?? "", storyLocation: locationTextField.text ?? "", storyContentsText: contentTextView.text, storyAudioTitle: audioTitle, storyAudioFileName: audioFileName, storyAudioPitch: audioPitch, storyAudioUrl: audioUrl, storyAudioData: audioData, storyPhotoImage: storyPhotoImageView.image, storyPhotoUrl: nil, storyTemplete: selectedTemplete)
            
            storyDetailViewController.storyData = storyData
            storyDetailViewController.pageCase = "storyPreview"
            
            self.navigationController?.pushViewController(storyDetailViewController, animated: false)
        }
    }
    
    @IBAction func addStoryRecord(_ sender: UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: Storyboard.audioRecord.name, bundle: nil)
        guard let recordSoundViewController = storyboard.instantiateViewController(identifier: "RecordSoundViewController") as? RecordSoundViewController else {
            return
        }
        
        recordSoundViewController.completionHandler = { [weak self] data in
            self?.audioPlayerView.backgroundColor = .white
            self?.audioPlayerView.addShadow(width: 2, height: 2, radius: 2, opacity: 0.2)
            
            guard let locationText = self?.locationTextField.text,
                  let titleText = self?.titleTextField.text else {
                return
            }
            
            if !locationText.isEmpty, !titleText.isEmpty {
                self?.rightBarButton.backgroundColor = UIColor.CustomColor.vodaMainBlue
            }
            
            guard let audioTitle = data.audioTitle else {
                return
            }
            self?.audioTitleLabel.isHidden = false
            self?.audioTitleLabel.text = "\(audioTitle).mp3"
            self?.audioTitleLabel.textColor = .black
            self?.audioTitle = audioTitle
            self?.audioTitleLabelPlaceHolder.isHidden = true
            self?.audioPlayingTimeLabel.isHidden = false
            self?.audioPlayButton.isHidden = false
            self?.audioPlayImageVIew.isHidden = false
            
            guard let pitch = data.pitch else {
                return
            }
            self?.audioPitch = pitch
            
            if let pitchValue = AudioPitch(rawValue: pitch) {
                self?.setRecordButtonImage(pitch: pitchValue)
            }
            
            guard let audioDataUrl = data.audioUrl else {
                return
            }
            self?.audioUrl = "\(audioDataUrl)"
            
            guard let audioDataFileName = data.audioFileName else {
                return
            }
            self?.audioFileName = audioDataFileName
        }
        
        if audioTitleLabelPlaceHolder.isHidden {
            showButtonPopUp(with: .reRecord, completionHandler: {
                self.navigationController?.pushViewController(recordSoundViewController, animated: false)
            })
        } else {
            self.navigationController?.pushViewController(recordSoundViewController, animated: false)
        }
    }
    
    @IBAction func deleteStoryRecord(_ sender: UIButton) {
        audioPlayerView.backgroundColor = UIColor.CustomColor.vodaGray2
        audioPlayerView.addShadow(width: 0, height: 0, radius: 0, opacity: 0)
        
        audioUrl = nil
        addRecordButton.setImage(UIImage(named: "voiceAdd"), for: .normal)
        audioTitleLabelPlaceHolder.isHidden = false
        audioTitleLabel.isHidden = true
        audioPlayingTimeLabel.isHidden = true
        audioPlayButton.isHidden = true
        audioPlayImageVIew.isHidden = true
    }
    
    @IBAction func playSound(_ sender: UIButton) {
        if isPlaying {
            audioPlayer.pause()
            isPlaying = false
        } else {
            if status == .paused {
                audioPlayer.resume()
            } else {
                guard let recordedAudioUrl = URL(string: audioUrl ?? "") else {
                    return
                }
                audioPlayer.play(with: recordedAudioUrl)
            }
            isPlaying = true
        }
    }
    
    @IBAction func addStoryPhoto(_ sender: UITapGestureRecognizer) {
        showAddPhotoPopUp(completionHandler: { [weak self] image in
            self?.storyPhotoImageView.image = image
        })
    }
    
    @IBAction func deleteStoryPhoto(_ sender: UIButton) {
        storyPhotoImageView.image = nil
    }
    
    @IBAction func selectNoTemplete(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        selectedTemplete = 0
        
        if sender.isSelected {
            catTempleteButton.isSelected = false
            cloudTempleteButton.isSelected = false
        }
        
        if !sender.isSelected, !catTempleteButton.isSelected, !cloudTempleteButton.isSelected {
            sender.isSelected = true
        }
    }
    
    @IBAction func selectCatTemplete(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        selectedTemplete = 1
        
        if sender.isSelected {
            noSelectTempleteButton.isSelected = false
            cloudTempleteButton.isSelected = false
        }
        
        if !sender.isSelected, !catTempleteButton.isSelected, !cloudTempleteButton.isSelected {
            sender.isSelected = true
        }
    }
    
    @IBAction func selectCloudTemplete(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        selectedTemplete = 2
        
        if sender.isSelected {
            noSelectTempleteButton.isSelected = false
            catTempleteButton.isSelected = false
        }
        
        if !sender.isSelected, !catTempleteButton.isSelected, !cloudTempleteButton.isSelected {
            sender.isSelected = true
        }
    }
}

// MARK: UITextFieldDelegate
extension WriteStoryViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var maxLength: Int = 0
        
        if textField == titleTextField {
            maxLength = 15
        } else if textField == locationTextField {
            maxLength = 25
        }
        
        guard let currentText = textField.text else {
            return false
        }
        
        guard let textRange = Range(range, in: currentText) else {
            return false
        }
        
        let limitedText = currentText.replacingCharacters(in: textRange, with: string)
        
        return limitedText.count <= maxLength
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        rightBarButton.backgroundColor = UIColor.CustomColor.vodaGray4
    }
}

// MARK: UITextViewDelegate
extension WriteStoryViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        guard let locationText = locationTextField.text else {
            return
        }
        
        guard let titleText = titleTextField.text else {
            return
        }
        
        if !textView.text.isEmpty, !locationText.isEmpty, !titleText.isEmpty {
            rightBarButton.backgroundColor = UIColor.CustomColor.vodaMainBlue
        }
        
        contentTextViewCharacterCountLabel.text = "\(textView.text.count)/5000자"
        
        let isReachedTextViewHeight = contentTextViewHeight.constant >= textViewHeight
        if isReachedTextViewHeight {
            let sizeToFitIn = CGSize(width: contentTextView.bounds.size.width, height: CGFloat(MAXFLOAT))
            let newSize = contentTextView.sizeThatFits(sizeToFitIn)
            contentTextViewHeight.constant = newSize.height
            
            let isNotReachedTextViewHeight = contentTextViewHeight.constant < textViewHeight
            if isNotReachedTextViewHeight {
                contentTextViewHeight.constant = textViewHeight
            }
            
            if contentTextViewHeight.constant > textViewHeight, contentTextViewHeight.constant > contentTextView.contentSize.height {
                totalViewHeight.constant += newSize.height - contentTextView.contentSize.height
            } else {
                totalViewHeight.constant -= contentTextView.contentSize.height - contentTextViewHeight.constant
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let contentTextView = contentTextView.text ?? ""
        guard let stringRange = Range(range, in: contentTextView) else {
            return false
        }
        let limitedContentTextView = contentTextView.replacingCharacters(in: stringRange, with: text)
        return limitedContentTextView.count <= 5000
    }
    
    private func setContentTextViewPlaceHolder() {
        contentTextView.text = "내용을 적어주세요"
        contentTextView.textColor = UIColor.CustomColor.vodaGray6
        contentTextView.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if contentTextView.text == "내용을 적어주세요" {
            contentTextView.text = nil
            contentTextView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if contentTextView.text.isEmpty {
            setContentTextViewPlaceHolder()
            contentTextViewCharacterCountLabel.text = "0/5000자"
            rightBarButton.backgroundColor = UIColor.CustomColor.vodaGray4
        }
    }
}

// MARK: UIScrollViewDelegate
extension WriteStoryViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
}

// MARK: AudioPlayable
extension WriteStoryViewController: AudioPlayable {
    func audioPlayer(_ audioPlayer: VodaAudioPlayer, didChangedStatus status: AudioPlayerStatus) {
        if status == .stopped {
            isPlaying = false
        }
        changeAudioPlayStatusButtonImage(status)
    }
    
    func audioPlayer(_ audioPlayer: VodaAudioPlayer, didUpdateCurrentTime currentTime: TimeInterval) {
        audioPlayingTimeLabel.text = currentTime.convertString()
    }
}

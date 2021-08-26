//
//  WriteStoryViewController.swift
//  VODA_iOS
//
//  Created by 전소영 on 2021/08/18.
//

import UIKit

class WriteStoryViewController: UIViewController {
    @IBOutlet weak var currentDateLabel: UILabel!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var audioTitleLabel: UILabel!
    @IBOutlet weak var addRecordButton: UIButton!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var contentTextViewHeight: NSLayoutConstraint!
    @IBOutlet weak var totalViewHeight: NSLayoutConstraint!
    @IBOutlet weak var contentTextViewCharacterCountLabel: UILabel!
    @IBOutlet weak var storyPhotoImageView: UIImageView!
    @IBOutlet weak var noSelectTempleteButton: UIButton!
    @IBOutlet weak var pinkCatTempleteButton: UIButton!
    @IBOutlet weak var yellowCatTempleteButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    private var textViewHeight: CGFloat = 0
    private var audioTitle: String?
    private var audioPitch: Float = 0
    private var audioUrl: String?
    
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
        
        currentDateLabel.text = getCurrentDate()
        setContentTextViewPlaceHolder()
        
        textViewHeight = DeviceInfo.screenHeight * 0.32881
        contentTextViewHeight.constant = textViewHeight
        
        setUpNavigationBarUI()
        addTempleteButtonShadow()
        //FIXME: 추후 삭제
        (rootViewController as? MainViewController)?.setTabBarHidden(true)
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
    
    private func addTempleteButtonShadow() {
        noSelectTempleteButton.addShadow(width: 2, height: 2, radius: 2, opacity: 0.2)
        pinkCatTempleteButton.addShadow(width: 2, height: 2, radius: 2, opacity: 0.2)
        yellowCatTempleteButton.addShadow(width: 2, height: 2, radius: 2, opacity: 0.2)
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
        
        if audioTitleLabel.textColor != .black, contentTextViewCharacterCountLabel.text == "0/5000자" {
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
            
            // FIXME: storyTemplete 서버 형식이랑 통일하기
            let storyData = StoryData(storyWriteDate: currentDateLabel.text ?? "", storyTitle: titleTextField.text ?? "", storyLocation: locationTextField.text ?? "", storyContentsText: contentTextView.text, storyAudioTitle: audioTitle, storyAudioPitch: audioPitch, storyAudioUrl: audioUrl, storyPhotoImage: storyPhotoImageView.image, storyPhotoUrl: nil, storyTemplete: nil)
            
            storyDetailViewController.storyData = storyData
            storyDetailViewController.pageCase = "storyPreview"
            
            self.navigationController?.pushViewController(storyDetailViewController, animated: false)
        }
    }
    
    @IBAction func addRecord(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "AudioRecord", bundle: nil)
        guard let recordSoundViewController = storyboard.instantiateViewController(identifier: "RecordSoundViewController") as? RecordSoundViewController else {
            return
        }
        
        recordSoundViewController.completionHandler = { [weak self] data in
            guard let locationText = self?.locationTextField.text else {
                return
            }
            
            guard let titleText = self?.titleTextField.text else {
                return
            }
            
            if !locationText.isEmpty, !titleText.isEmpty {
                self?.rightBarButton.backgroundColor = UIColor.CustomColor.vodaMainBlue
            }
            
            guard let audioTitle = data.audioTitle else {
                return
            }
            self?.audioTitleLabel.text = "\(audioTitle).mp3"
            self?.audioTitleLabel.textColor = .black
            self?.audioTitle = audioTitle
            
            guard let pitch = data.pitch else {
                return
            }
            
            self?.audioPitch = pitch
            
            switch pitch {
            case 0:
                self?.addRecordButton.setImage(UIImage(named: "noEffectHover"), for: .normal)
            case -800:
                self?.addRecordButton.setImage(UIImage(named: "thickHover"), for: .normal)
            case 1000:
                self?.addRecordButton.setImage(UIImage(named: "thinHover"), for: .normal)
            default:
                break
            }
            
            guard let audioDataUrl = data.audioUrl else {
                return
            }
            
            self?.audioUrl = "\(audioDataUrl)"
        }
        
        self.navigationController?.pushViewController(recordSoundViewController, animated: false)
    }
    
    @IBAction func addStoryPhoto(_ sender: UITapGestureRecognizer) {
        showAddPhotoPopUp(completionHandler: { [weak self] image in
            self?.storyPhotoImageView.image = image
        })
    }
    
    @IBAction func selectNoSeletTemplete(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            pinkCatTempleteButton.isSelected = false
            yellowCatTempleteButton.isSelected = false
        }
    }
    
    @IBAction func selectPinkCatTemplete(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            noSelectTempleteButton.isSelected = false
            yellowCatTempleteButton.isSelected = false
        }
    }
    
    @IBAction func selectYellowCatTemplete(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            noSelectTempleteButton.isSelected = false
            pinkCatTempleteButton.isSelected = false
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
        guard let locationText = locationTextField.text else {
            return
        }
        
        guard let titleText = titleTextField.text else {
            return
        }
        
        if !titleText.isEmpty, !locationText.isEmpty {
            if contentTextViewCharacterCountLabel.text != "0/5000자" || audioTitleLabel.text != "음성으로 기록하기" {
                rightBarButton.backgroundColor = UIColor.CustomColor.vodaMainBlue
            }
        } else {
            rightBarButton.backgroundColor = UIColor.CustomColor.vodaGray4
        }
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

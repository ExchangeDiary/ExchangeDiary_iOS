//
//  WriteStoryViewController.swift
//  VODA_iOS
//
//  Created by 전소영 on 2021/08/18.
//

import UIKit

class WriteStoryViewController: UIViewController {
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var contentTextViewHeight: NSLayoutConstraint!
    @IBOutlet weak var totalViewHeight: NSLayoutConstraint!
    @IBOutlet weak var contentTextViewCharacterCount: UILabel!
    @IBOutlet weak var storyPhoto: UIImageView!
    @IBOutlet weak var noSelectTempleteButton: UIButton!
    @IBOutlet weak var pinkCatTempleteButton: UIButton!
    @IBOutlet weak var yellowCatTempleteButton: UIButton!
    private var textViewHeight: CGFloat = 0
    
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
        
        locationTextField.delegate = self
        titleTextField.delegate = self
        contentTextView.delegate = self
        
        setContentTextViewPlaceHolder()
        
        textViewHeight = DeviceInfo.screenHeight * 0.32881
        contentTextViewHeight.constant = textViewHeight
        
        setupNavigationBarUI()
        addTempleteButtonShadow()
        //FIXME: 추후 삭제
        (rootViewController as? MainViewController)?.setTabBarHidden(true)
    }
    
    private func setupNavigationBarUI() {
        self.setNavigationBarTransparency()
        self.setBackButton(color: .black)
        
        let rightBarButtonItem = UIBarButtonItem(customView: rightBarButton)
        //FIXME: popup 닫히는 함수 연결하기
        //        rightBarButton.addTarget(self, action: #selector(), for: .touchUpInside)
        self.navigationItem.setRightBarButtonItems([rightBarButtonItem], animated: false)
    }
    
    private func addTempleteButtonShadow() {
        noSelectTempleteButton.addShadow(width: 2, height: 2, radius: 2, opacity: 0.2)
        pinkCatTempleteButton.addShadow(width: 2, height: 2, radius: 2, opacity: 0.2)
        yellowCatTempleteButton.addShadow(width: 2, height: 2, radius: 2, opacity: 0.2)
    }
    
    @IBAction func addStoryPhoto(_ sender: UITapGestureRecognizer) {
        showAddPhotoPopUp(completionHandler: { [weak self] (image) in
            self?.storyPhoto.image = image
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
}

// MARK: UITextViewDelegate
extension WriteStoryViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        contentTextViewCharacterCount.text = "\(textView.text.count)/5000자"
        
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
        if !contentTextView.text.isEmpty {
            contentTextView.text = nil
            contentTextView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if contentTextView.text.isEmpty {
            setContentTextViewPlaceHolder()
            contentTextViewCharacterCount.text = "0/5000자"
        }
    }
}
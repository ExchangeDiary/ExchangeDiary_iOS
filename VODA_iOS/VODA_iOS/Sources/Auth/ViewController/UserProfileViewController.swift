//
//  UserProfileViewController.swift
//  VODA_iOS
//
//  Created by 전소영 on 2021/09/01.
//

import UIKit

class UserProfileViewController: UIViewController {
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var userProfileEditImageView: UIImageView!
    @IBOutlet weak var userNickNameTextFieldView: UIView!
    @IBOutlet weak var userNickNameTextField: UITextField!
    @IBOutlet weak var completeButtonView: UIView!
    @IBOutlet weak var completeButton: UIButton!
    
    var pageCase: String?
    var completionHandler: ((UserProfileData) -> Void)?
    var userProfileImage: UIImage?
    var userNickName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let profileImage = userProfileImage, let nickName = userNickName {
            userProfileImageView.image = profileImage
            userNickNameTextField.text = nickName
        }
        
        self.setBackButton(color: .black)
        (rootViewController as? MainViewController)?.setTabBarHidden(true)
        
        addTapGesture()
        self.userNickNameTextField.addTarget(self, action: #selector(self.checkUserNickNameLength), for: .editingChanged)
        makeCompleteButtonDisabled()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        checkUserNickNameLength(userNickNameTextField)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.userProfileImageView.makeCircleView()
        self.userNickNameTextFieldView.makeCornerRadius(radius: 8)
        self.completeButtonView.makeCornerRadius(radius: 16)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func addTapGesture() {
        userProfileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addPhoto)))
        userProfileEditImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addPhoto)))
    }
    
    private func makeCompleteButtonDisabled() {
        self.completeButtonView.backgroundColor = #colorLiteral(red: 0.8784313725, green: 0.8784313725, blue: 0.8784313725, alpha: 1)
        self.completeButton.isEnabled = false
    }
    
    private func makeCompleteButtonEnabled() {
        self.completeButtonView.backgroundColor = UIColor.CustomColor.vodaMainBlue
        self.completeButton.isEnabled = true
    }
    
    @objc private func addPhoto() {
        showAddPhotoPopUp(completionHandler: { [weak self] image in
            self?.userProfileImageView.image = image
        })
    }
    
    @objc func checkUserNickNameLength(_ sender: UITextField) {
        if let userNickNameLength = self.userNickNameTextField.text?.count {
            if userNickNameLength > 0 {
                makeCompleteButtonEnabled()
            } else {
                makeCompleteButtonDisabled()
            }
        }
    }
    
    @IBAction func completeUserInfoSetting(_ sender: UIButton) {
        if pageCase == "myPage" {
            if let profileUserImage = userProfileImageView.image, let userNickName = userNickNameTextField.text {
                completionHandler?(UserProfileData(userNickName: "\(userNickName)님", userProfileImage: profileUserImage, userProfileImageUrl: nil, userEmail: nil))
                navigationController?.popViewController(animated: false)
            }
        } else if pageCase == "Auth" {
            if let mainViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainViewController") as? MainViewController {
                mainViewController.modalPresentationStyle = .fullScreen
                mainViewController.modalTransitionStyle = .crossDissolve
                self.present(mainViewController, animated: true)
            }
        }
    }
}

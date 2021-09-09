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
    @IBOutlet weak var userNickNameTextField: UITextField!
    var pageCase: String?
    var completionHandler: ((UserProfileData) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTapGesture()
        userProfileImageView.makeCircleView()
        self.setBackButton(color: .black)
        
        (rootViewController as? MainViewController)?.setTabBarHidden(true)
    }
    
    private func addTapGesture() {
        userProfileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addPhoto)))
        userProfileEditImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addPhoto)))
    }
    
    @objc private func addPhoto() {
        showAddPhotoPopUp(completionHandler: { [weak self] image in
            self?.userProfileImageView.image = image
        })
    }
    
    @IBAction func completeUserInfoSetting(_ sender: UIButton) {
        //TODO: 이미지, 닉네임 nil체크 버튼 비활성화 추가
        if pageCase == "myPage" {
            if let profileUserImage = userProfileImageView.image {
                completionHandler?(UserProfileData(userNickName: "\(userNickNameTextField.text)님", userProfileImage: profileUserImage, userProfileImageUrl: nil, userEmail: nil))
            }
        }
        navigationController?.popViewController(animated: false)
    }
}

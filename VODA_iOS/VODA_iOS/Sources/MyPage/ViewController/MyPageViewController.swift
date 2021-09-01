//
//  MyPageViewController.swift
//  VODA_iOS
//
//  Created by 전소영 on 2021/07/30.
//

import UIKit

class MyPageViewController: UIViewController {
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var userProfileEditImageView: UIImageView!
    @IBOutlet weak var userNickNameLabel: UILabel!
    @IBOutlet weak var myPageView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationBarColor(color: .clear)
        userProfileImageView.makeCircleImageView()
        myPageView.addShadow(width: 0, height: -4, radius: 8, opacity: 0.1)
        addTapGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setNavigationBarColor(color: .clear)
        (rootViewController as? MainViewController)?.setTabBarHidden(false)
    }
    
    private func addTapGesture() {
        userProfileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(moveToUserProfileViewController(_:))))
        userProfileEditImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(moveToUserProfileViewController(_:))))
    }
    
    @objc private func moveToUserProfileViewController(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Auth", bundle: nil)
        guard let userProfileViewController = storyboard.instantiateViewController(identifier: "UserProfileViewController") as? UserProfileViewController else {
            return
        }
        
        userProfileViewController.pageCase = "myPage"
        
        userProfileViewController.completionHandler = { [weak self] data in
            self?.userProfileImageView.image = data.userProfileImage
            self?.userNickNameLabel.text = data.userNickName
        }
        
        self.navigationController?.pushViewController(userProfileViewController, animated: false)
    }
}

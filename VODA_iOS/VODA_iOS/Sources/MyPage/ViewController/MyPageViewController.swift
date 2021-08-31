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
    @IBOutlet weak var userNickName: UILabel!
    @IBOutlet weak var myPageView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationBarColor(color: .clear)
        myPageView.addShadow(width: 0, height: -4, radius: 8, opacity: 0.1)
        setUpUserInfoUI()
    }
    
    private func setUpUserInfoUI() {
        userProfileImageView.makeCircleImageView()
        
        userProfileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(moveToUserInfoSetting)))
        userProfileEditImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(moveToUserInfoSetting)))
    }
    
    @objc private func moveToUserInfoSetting() {
        //TODO: nickName 변경 페이지로 연결
    }
}

//
//  StoryDetailViewController.swift
//  VODA_iOS
//
//  Created by 전소영 on 2021/08/22.
//

import UIKit

class StoryDetailViewController: UIViewController {
    @IBOutlet weak var storyTextView: UITextView!
    @IBOutlet weak var storyPhotoImageView: UIImageView!
    @IBOutlet weak var audioMiniPlayerView: UIView!
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
        
        setUpNavigationBarUI()
        setUpAudioPlayUI()
    }
    
    private func setUpNavigationBarUI() {
        self.setNavigationBarTransparency()
        self.setBackButton(color: .black)
        
        let rightBarButtonItem = UIBarButtonItem(customView: rightBarButton)
        //TODO: 서버에 보내기
//        rightBarButton.addTarget(self, action: #selector(), for: .touchUpInside)
        self.navigationItem.setRightBarButtonItems([rightBarButtonItem], animated: false)
    }
    
    private func setUpAudioPlayUI() {
        audioMiniPlayerView.addShadow(width: 0, height: -3, radius: 3, opacity: 0.1)
    }
}

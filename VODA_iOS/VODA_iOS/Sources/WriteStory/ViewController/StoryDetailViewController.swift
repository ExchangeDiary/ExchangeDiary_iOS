//
//  StoryDetailViewController.swift
//  VODA_iOS
//
//  Created by 전소영 on 2021/08/22.
//

import UIKit

class StoryDetailViewController: UIViewController {
    @IBOutlet weak var voiceSoundShortView: UIView!
    @IBOutlet weak var voiceSoundLongView: UIView!

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
        addVoiceSoundViewShadow()
    }
    
    private func setUpNavigationBarUI() {
        self.setNavigationBarTransparency()
        self.setBackButton(color: .black)
        
        let rightBarButtonItem = UIBarButtonItem(customView: rightBarButton)
        //TODO: 서버에 보내기
//        rightBarButton.addTarget(self, action: #selector(), for: .touchUpInside)
        self.navigationItem.setRightBarButtonItems([rightBarButtonItem], animated: false)
    }
    
    private func addVoiceSoundViewShadow() {
        voiceSoundShortView.addShadow(width: 2, height: 2, radius: 2, opacity: 0.2)
        voiceSoundLongView.addShadow(width: 2, height: 2, radius: 2, opacity: 0.2)
    }
    
    //TODO: 전체 길이가 넘으면 스크롤 되는 뷰에 그만큼 더해주기
    @IBAction func voiceSoundLongViewShow(_ sender: Any) {
        voiceSoundLongView.isHidden = false
    }
    
    @IBAction func voiceSoundLongViewHidden(_ sender: Any) {
        voiceSoundLongView.isHidden = true
    }
}

//
//  WriteStoryViewController.swift
//  VODA_iOS
//
//  Created by 전소영 on 2021/08/18.
//

import UIKit

class WriteStoryViewController: UIViewController {
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var contentTextViewHeight: NSLayoutConstraint!
    
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
        setupNavigationBarUI()
        //FIXME: 추후 삭제
        (rootViewController as? MainViewController)?.setTabBarHidden(true)
    
        contentTextView.delegate = self
        contentTextView.contentSize.height = 265
//        contentTextView.sizeToFit()
    }
    
    private func setupNavigationBarUI() {
        self.setNavigationBarTransparency()
        self.setBackButton(color: .black)
        
        let rightBarButtonItem = UIBarButtonItem(customView: rightBarButton)
        //FIXME: popup 닫히는 함수 연결하기
//        rightBarButton.addTarget(self, action: #selector(), for: .touchUpInside)
        self.navigationItem.setRightBarButtonItems([rightBarButtonItem], animated: false)
    }

}

extension WriteStoryViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if contentTextViewHeight.constant < 265 {
            print("contentTextViewHeight.constant1: \(contentTextViewHeight.constant)")
            contentTextViewHeight.constant = 265
        } else {
            print("contentTextViewHeight.constant2: \(contentTextViewHeight.constant)")
            let sizeToFitIn = CGSize(width: contentTextView.bounds.size.width, height: CGFloat(MAXFLOAT))
            let newSize = contentTextView.sizeThatFits(sizeToFitIn)
            contentTextViewHeight.constant = newSize.height
            if contentTextViewHeight.constant < 265 {
                contentTextViewHeight.constant = 265
            }
            print("contentTextViewHeight.constant3: \(contentTextViewHeight.constant)")
        }
    }
}

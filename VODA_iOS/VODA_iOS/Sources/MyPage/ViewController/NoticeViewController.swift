//
//  NoticeViewController.swift
//  VODA_iOS
//
//  Created by 전소영 on 2021/08/31.
//

import UIKit

class NoticeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpNavigationUI()
    }
    
    private func setUpNavigationUI() {
        self.setBackButton(color: .black)
        self.setNavigationBarTransparency()
        
        self.navigationController?.navigationBar.titleTextAttributes = [.font: UIFont(name: "AppleSDGothicNeo-SemiBold", size: 20.0) as Any, .foregroundColor: UIColor.CustomColor.vodaGray9]
    }
}

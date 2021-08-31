//
//  QuestionViewController.swift
//  VODA_iOS
//
//  Created by 전소영 on 2021/09/01.
//

import UIKit

class QuestionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpNavigationUI()
    }
    
    private func setUpNavigationUI() {
        self.setBackButton(color: .black)
        self.setNavigationBarTransparency()
        
        self.navigationController?.navigationBar.titleTextAttributes = [.font: UIFont(name: "AppleSDGothicNeo-SemiBold", size: 20.0) as Any, .foregroundColor: UIColor.CustomColor.vodaGray9]
    }
    
    @IBAction func pasteVodaEmail(_ sender: UIButton) {
        UIPasteboard.general.string = "voice.of.diary.official@gmail.com"
        print("clipBoard paste complete")
    }
}

//
//  PushSettingViewController.swift
//  VODA_iOS
//
//  Created by 전소영 on 2021/08/31.
//

import UIKit

class PushSettingViewController: UIViewController {
    @IBOutlet weak var pushSettingSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavigationUI()
        setPushSettingSwitch()
    }
    
    private func setUpNavigationUI() {
        self.setBackButton(color: .black)
        self.setNavigationBarTransparency()
        
        self.navigationController?.navigationBar.titleTextAttributes = [.font: UIFont(name: "AppleSDGothicNeo-SemiBold", size: 20.0) as Any, .foregroundColor: UIColor.CustomColor.vodaGray9]
    }
    
    private func setPushSettingSwitch() {
        if UIApplication.shared.isRegisteredForRemoteNotifications {
            pushSettingSwitch.isOn = true
        } else {
            pushSettingSwitch.isOn = false
        }
    }
 
    @IBAction func togglePushSettingSwitch(_ sender: UISwitch) {
        if sender.isOn {
            UIApplication.shared.registerForRemoteNotifications()
        } else {
            UIApplication.shared.unregisterForRemoteNotifications()
        }
    }
}

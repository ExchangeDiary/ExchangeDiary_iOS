//
//  PushViewController.swift
//  VODA_iOS
//
//  Created by 전소영 on 2021/07/30.
//

import UIKit

class PushViewController: UIViewController {
    @IBOutlet weak var pushView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setNavigationBarColor(color: .clear)
        pushView.addShadow(width: 0, height: -4, radius: 8, opacity: 0.1)
    }
}

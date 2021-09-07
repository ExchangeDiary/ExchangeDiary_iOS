//
//  LoadingViewController.swift
//  VODA_iOS
//
//  Created by 전소영 on 2021/09/07.
//

import UIKit
import Lottie

class LoadingViewController: UIViewController {
    @IBOutlet weak var loadingImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let animationView = AnimationView(name: "loading")
        
        animationView.frame = CGRect(x: 0, y: 0, width: DeviceInfo.screenWidth * 100/375, height: DeviceInfo.screenWidth * 70/375)
        animationView.contentMode = .scaleAspectFill
        animationView.center.x = view.center.x
        animationView.center.y = view.center.y - (DeviceInfo.screenWidth * 110/375)
        view.addSubview(animationView)
        
        animationView.loopMode = .loop
        animationView.play()
    }
}

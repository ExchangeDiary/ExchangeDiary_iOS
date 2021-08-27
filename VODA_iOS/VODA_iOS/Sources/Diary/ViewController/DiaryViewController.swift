//
//  DiaryViewController.swift
//  VODA_iOS
//
//  Created by 조윤영 on 2021/08/15.
//

import UIKit

class DiaryViewController: UIViewController {
    @IBOutlet weak var diaryCollectionView: UICollectionView!

    var status: String = "writing"
    let participantsDummy: [String] = ["yoonyoung", "soyoung"]

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        (rootViewController as? MainViewController)?.setTabBarHidden(true)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    @IBAction func tempBackButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

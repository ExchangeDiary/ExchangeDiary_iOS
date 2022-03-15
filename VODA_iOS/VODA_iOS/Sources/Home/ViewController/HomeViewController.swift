//
//  HomeViewController.swift
//  VODA_iOS
//
//  Created by 전소영 on 2021/07/30.
//

import UIKit
import DropDown

class HomeViewController: UIViewController {
    @IBOutlet weak var joinedDiaryCollectionView: UICollectionView!
    var participants = [UIImageView]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationBarColor(color: UIColor.CustomColor.vodaGray2)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.navigationController?.setNavigationBarTransparency()
    }
    
    func pushDiaryViewController() {
        let diaryViewController = UIStoryboard(name: "Diary", bundle: nil).instantiateViewController(withIdentifier: "DiaryViewController")
        diaryViewController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(diaryViewController, animated: true)
    }
    
    @IBAction func pushPushViewController(_ sender: UIBarButtonItem) {
        let pushViewController = UIStoryboard(name: "Push", bundle: nil).instantiateViewController(withIdentifier: "PushViewController")
        self.navigationController?.pushViewController(pushViewController, animated: true)
    }
}

//
//  HomeViewController.swift
//  VODA_iOS
//
//  Created by 전소영 on 2021/07/30.
//

import UIKit

class HomeViewController: UIViewController {
    
    var windowHeight = UIScreen.main.bounds.size.height
    var windowWidth = UIScreen.main.bounds.size.width

    @IBOutlet weak var joinedDiaryCollectionView: UICollectionView!
    @IBOutlet weak var createNewDiaryButton: UIBarButtonItem!
    var participants = [UIImageView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.navigationController?.setNavigationBarTransparency()
        self.createNewDiaryButton.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
}

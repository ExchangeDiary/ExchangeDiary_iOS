//
//  WritingOrderModifyViewController.swift
//  VODA_iOS
//
//  Created by 조윤영 on 2021/09/21.
//

import UIKit

class WritingOrderModifyViewController: UIViewController {
    @IBOutlet weak var completButtonView: UIView!
    @IBOutlet weak var wrtingOrderCollectionView: UICollectionView!
    let writingOrderModifyCellIdentifier = "WritingOrderModifyCell"
    var participants = ["조윤영1", "조윤영2", "조윤영3", "조윤영4", "조윤영5", "조윤영6", "조윤영7", "조윤영8"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        setStyle()
    }
    
    func setStyle() {
        (rootViewController as? MainViewController)?.setTabBarHidden(true)
        self.setNavigationBarColor(color: UIColor.clear)
        self.setBackButton(color: .black)
        
        self.completButtonView.makeCornerRadius(radius: 16)
    }
}

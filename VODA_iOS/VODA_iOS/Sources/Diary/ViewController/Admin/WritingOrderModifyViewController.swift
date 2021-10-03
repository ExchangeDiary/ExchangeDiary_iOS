//
//  WritingOrderModifyViewController.swift
//  VODA_iOS
//
//  Created by 조윤영 on 2021/09/21.
//

import UIKit

class WritingOrderModifyViewController: UIViewController {
    @IBOutlet weak var completeButtonView: UIView!
    @IBOutlet weak var writingOrderCollectionView: UICollectionView!
    let writingOrderModifyCellIdentifier = "WritingOrderModifyCell"
    var participants = ["조윤영1", "조윤영2", "조윤영3", "조윤영4", "조윤영5", "조윤영6", "조윤영7", "조윤영8"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.writingOrderCollectionView.dragInteractionEnabled = true
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        setStyle()
    }
    
    private func setStyle() {
        (rootViewController as? MainViewController)?.setTabBarHidden(true)
        self.setNavigationBarColor(color: UIColor.clear)
        self.setBackButton(color: .black)
        
        self.completeButtonView.makeCornerRadius(radius: 16)
    }
}

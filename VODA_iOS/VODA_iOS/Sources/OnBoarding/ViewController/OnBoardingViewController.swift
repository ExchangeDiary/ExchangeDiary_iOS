//
//  OnBoardingViewController.swift
//  VODA_iOS
//
//  Created by 조윤영 on 2021/10/03.
//

import UIKit

class OnBoardingViewController: UIViewController {

    @IBOutlet weak var onboardingCollectionView: UICollectionView!
    @IBOutlet weak var onBoardingpageControl: UIPageControl!
    
    let onBoardingCell1Identifier = "onBoardingCell1Identifier"
    let onBoardingCell2Identifier = "onBoardingCell2Identifier"
    let onBoardingCell3Identifier = "onBoardingCell3Identifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.onBoardingpageControl.backgroundStyle = .minimal
        self.onBoardingpageControl.allowsContinuousInteraction = false
    }
    
    private func visibleCellIndexPath() -> IndexPath {
        return self.onboardingCollectionView.indexPathsForVisibleItems[0]
    }
    
    @IBAction func skipTouchUpInsideAction(_ sender: Any) {
        self.onboardingCollectionView.scrollToItem(at: IndexPath(item: 2, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    @IBAction func startTouchUpInsideAction(_ sender: Any) {
        if let mainViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainViewController") as? MainViewController {
            mainViewController.modalPresentationStyle = .fullScreen
            mainViewController.modalTransitionStyle = .crossDissolve
            self.present(mainViewController, animated: true)
        }
    }
}

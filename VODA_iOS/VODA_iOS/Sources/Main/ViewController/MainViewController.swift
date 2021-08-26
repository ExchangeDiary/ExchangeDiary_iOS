//
//  MainViewController.swift
//  VODA_iOS
//
//  Created by 전소영 on 2021/07/10.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var pushView: UIView!
    @IBOutlet weak var homeView: UIView!
    @IBOutlet weak var myPageView: UIView!
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var homeTabBarItem: UITabBarItem!
    @IBOutlet weak var shadowView: UIView!
    private var pushViewController: PushViewController?
    private var homeViewController: HomeViewController?
    private var myPageViewController: MyPageViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTabBarUI()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case MainTab.push.segueIdentifier:
            let navigationController = segue.destination as? UINavigationController
            pushViewController = navigationController?.topViewController as? PushViewController
        case MainTab.home.segueIdentifier:
            homeViewController = segue.destination as? HomeViewController
        case MainTab.myPage.segueIdentifier:
            let navigationController = segue.destination as? UINavigationController
            myPageViewController = navigationController?.topViewController as? MyPageViewController
        default:
            break
        }
    }
    
    private func setUpTabBarUI() {
        tabBar.selectedItem = homeTabBarItem
        
        shadowView.layer.shadowColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1).cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0, height: -1)
        
        tabBar.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        tabBar.translatesAutoresizingMaskIntoConstraints = false
       
        view.bringSubviewToFront(shadowView)
    }
    
    func setTabBarHidden(_ isHidden: Bool) {
        print("???")
        tabBar.isHidden = isHidden
        shadowView.isHidden = isHidden
    }
}

// MARK: UITabBarDelegate
extension MainViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.tag {
        case MainTab.push.index:
            view.bringSubviewToFront(pushView)
        case MainTab.home.index:
            view.bringSubviewToFront(homeView)
        case MainTab.myPage.index:
            view.bringSubviewToFront(myPageView)
        default:
            break
        }
        
        view.bringSubviewToFront(shadowView)
    }
}

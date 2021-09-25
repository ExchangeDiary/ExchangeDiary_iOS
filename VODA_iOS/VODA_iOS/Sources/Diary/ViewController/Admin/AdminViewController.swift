//
//  AdminViewController.swift
//  VODA_iOS
//
//  Created by 조윤영 on 2021/09/21.
//

import UIKit

class AdminViewController: UIViewController {
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var writePeriodLabel: UILabel!
    
    private let writePeriodPopUpViewcontrollerIdentifier = "WritePeriodPopUpViewController"
    private let updateInvitationCodeViewControllerIdentifier = "UpdateInvitationCodeViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        setStyle()
    }
    
    private func setStyle() {
        (rootViewController as? MainViewController)?.setTabBarHidden(true)
        self.setBackButton(color: .black)
        self.setNavigationBarColor(color: UIColor.clear)
        
        self.headerView.makeTopSectionRound(16)
        self.headerView.addShadow(width: 0, height: -4, radius: 8, opacity: 0.05)
    }
    
    @IBAction func modifyCodeTouchUpInsideAction(_ sender: Any) {
        let dvc = UIStoryboard(name: "Diary", bundle: nil).instantiateViewController(withIdentifier: updateInvitationCodeViewControllerIdentifier)
        dvc.modalPresentationStyle = .overCurrentContext
        dvc.modalTransitionStyle = .crossDissolve
        self.present(dvc, animated: true, completion: nil)

    }
    
    @IBAction func writingPreiodTouchUpInsideAction(_ sender: Any) {
        let dvc = UIStoryboard(name: "PopUp", bundle: nil).instantiateViewController(withIdentifier: writePeriodPopUpViewcontrollerIdentifier) as? WritePeriodPopUpViewController
        dvc?.modalPresentationStyle = .overCurrentContext
        dvc?.modalTransitionStyle = .crossDissolve
        dvc?.writePeriodDelegate = self
        self.present(dvc ?? UIViewController(), animated: true, completion: nil)
    }
}

extension AdminViewController: WritePeriodPopUpDelegate {
    func changeWritePeriod(_ period: String) {
        self.writePeriodLabel.text = period
    }
}

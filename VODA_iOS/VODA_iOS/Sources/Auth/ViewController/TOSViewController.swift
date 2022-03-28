//
//  TOSViewController.swift
//  VODA_iOS
//
//  Created by 조윤영 on 2022/03/20.
//

import UIKit
import WebKit

class TOSViewController: UIViewController {
    @IBOutlet weak var fullAgreementCheckBoxButton: UIButton!
    @IBOutlet weak var over14yearsOldCheckBoxButton: UIButton!
    @IBOutlet weak var tosAgreementCheckBoxButton: UIButton!
    @IBOutlet weak var privacyPolicyAgreementCheckBoxButton: UIButton!
    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var showTOSAgreementDetailButton: UIButton!
    @IBOutlet weak var showPrivacyAgreementDetailButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setStyle()
        setCheckBoxStatus()
        setCompleteButtonDisabled()
    }
    
    func setStyle() {
        self.completeButton.makeCornerRadius(radius: 16)
    }
    
    @IBAction func checkBoxTouchUpInsideAction(_ sender: UIButton) {
        if sender == self.fullAgreementCheckBoxButton {
            let agreement = !self.fullAgreementCheckBoxButton.isSelected
            self.fullAgreementCheckBoxButton.isSelected = agreement
            self.over14yearsOldCheckBoxButton.isSelected = agreement
            self.tosAgreementCheckBoxButton.isSelected = agreement
            self.privacyPolicyAgreementCheckBoxButton.isSelected = agreement
        } else { sender.isSelected.toggle() }
        
        if checkIsCheckBoxAllSelected() {
            setCompleteButtonEnable()
            self.fullAgreementCheckBoxButton.isSelected = true
        } else {
            setCompleteButtonDisabled()
            self.fullAgreementCheckBoxButton.isSelected = false
        }
    }
    
    func checkIsCheckBoxAllSelected() -> Bool {
        if self.over14yearsOldCheckBoxButton.isSelected && self.tosAgreementCheckBoxButton.isSelected && self.privacyPolicyAgreementCheckBoxButton.isSelected {
            return true
        }
        
        return false
    }
    
    @IBAction func showAgreementDetail(_ sender: UIButton) {
        if let TOSWebViewController = UIStoryboard(name: Storyboard.auth.name, bundle: nil).instantiateViewController(withIdentifier: "TOSWebViewController") as? TOSWebViewController {
            var agreementUrl: URL?
            if sender == self.showTOSAgreementDetailButton {
                agreementUrl = TOSUrl.TOSAgreementUrl
            } else {
                agreementUrl = TOSUrl.PrivacyPolicyAgreemntUrl
            }
            
            TOSWebViewController.modalPresentationStyle = .fullScreen
            TOSWebViewController.url = agreementUrl
            self.navigationController?.pushViewController(TOSWebViewController, animated: true)
        }
    }
    
    func setCheckBoxStatus() {
        let checkBoxNoneImage = UIImage(named: "checkBox_none")
        let checkBoxActiveImage = UIImage(named: "checkBox_active")
        
        self.fullAgreementCheckBoxButton.setImage(checkBoxNoneImage, for: .normal)
        self.fullAgreementCheckBoxButton.setImage(checkBoxActiveImage, for: .selected)
        self.over14yearsOldCheckBoxButton.setImage(checkBoxNoneImage, for: .normal)
        self.over14yearsOldCheckBoxButton.setImage(checkBoxActiveImage, for: .selected)
        self.tosAgreementCheckBoxButton.setImage(checkBoxNoneImage, for: .normal)
        self.tosAgreementCheckBoxButton.setImage(checkBoxActiveImage, for: .selected)
        self.privacyPolicyAgreementCheckBoxButton.setImage(checkBoxNoneImage, for: .normal)
        self.privacyPolicyAgreementCheckBoxButton.setImage(checkBoxActiveImage, for: .selected)
    }
    
    func setCompleteButtonDisabled() {
        self.completeButton.isEnabled = false
        self.completeButton.backgroundColor = UIColor.CustomColor.vodaGray4
    }
    
    func setCompleteButtonEnable() {
        self.completeButton.isEnabled = true
        self.completeButton.backgroundColor = UIColor.CustomColor.vodaMainBlue
    }
}

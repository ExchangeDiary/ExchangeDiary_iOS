//
//  ButtonPopUpViewController.swift
//  VODA_iOS
//
//  Created by 전소영 on 2021/08/13.
//

import UIKit

class ButtonPopUpViewController: UIViewController {
    @IBOutlet weak var labelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    var popUpType: ButtonPopUpType?
    var completionHandler: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPopUpTypeUI()
    }
    
    private func setupPopUpTypeUI() {
        guard let popUpType = popUpType else {
            return
        }
        
        guard let topConstraint = popUpType.labelTopConstraint else {
            return
        }
        
        labelTopConstraint.constant = CGFloat(topConstraint)
        message.text = popUpType.message
        
        if popUpType.numberOfButton == 1 {
            cancelButton.isHidden = true
        } else {
            cancelButton.isHidden = false
        }
        
        confirmButton.setTitle(popUpType.confirmButtonTitle, for: .normal)
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func confirm(_ sender: Any) {
        self.dismiss(animated: false, completion: completionHandler)
    }
}

//
//  UpdateInvitationCodeViewController.swift
//  VODA_iOS
//
//  Created by 조윤영 on 2021/09/21.
//

import UIKit

class UpdateInvitationCodeViewController: UIViewController {
    @IBOutlet weak var popUpViewBottomConstraints: NSLayoutConstraint!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var codeInputView: UIView!
    
    @IBOutlet weak var hintInputView: UIView!
    @IBOutlet weak var completeButtonView: UIView!
    @IBOutlet weak var completeButton: UIButton!
    
    var originConstant: CGFloat = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        originConstant = self.popUpViewBottomConstraints.constant
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        setStyle()
    }
    
    func setStyle() {
        self.popUpView.makeCornerRadius(radius: 16)
        self.codeInputView.makeCornerRadius(radius: 8)
        self.hintInputView.makeCornerRadius(radius: 8)
        self.completeButtonView.makeCornerRadius(radius: 8)
    }
    
    @objc func keyboardWillAppear(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        let keyboardHeight = keyboardFrame.height / 2 - view.safeAreaInsets.bottom
        
        if self.popUpViewBottomConstraints.constant == CGFloat(originConstant) {
            UIView.animate(withDuration: 1.0, animations: {
                self.popUpViewBottomConstraints.constant += keyboardHeight
            })
        }
    }
    
    @objc func keyboardWillDisappear(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        let keyboardHeight = keyboardFrame.height / 2 - view.safeAreaInsets.bottom
        if self.popUpViewBottomConstraints.constant != CGFloat(originConstant) {
            UIView.animate(withDuration: 1.0, animations: {
                self.popUpViewBottomConstraints.constant -= keyboardHeight
            })
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         self.view.endEditing(true)
    }
    
    @IBAction func closePopUpTouchUpInsideAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

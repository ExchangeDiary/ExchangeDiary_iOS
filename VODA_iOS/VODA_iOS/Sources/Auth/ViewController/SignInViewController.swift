//
//  SignInViewController.swift
//  VODA_iOS
//
//  Created by 조윤영 on 2021/08/03.
//

import UIKit
import AuthenticationServices
import GoogleSignIn

class SignInViewController: UIViewController {
    
    @IBOutlet weak var googleLoginButton: UIButton!
    @IBOutlet weak var kakoLoginButton: UIButton!
    @IBOutlet weak var appleLoginButton: UIButton!
    
    let appleLoginManager = AppleLoginManager()
    let socialLoginManager = SocialLoginManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func googleLoginTouchUpInsideAction(_ sender: Any) {
        socialLoginManager.login(with: .google, viewController: self)
    }
    
    @IBAction func kakaoLoginTouchUpInsideAction(_ sender: Any) {
        socialLoginManager.login(with: .kakao, viewController: self)
    }
    
    @available(iOS 13.0, *)
    @IBAction func appleLoginTouchUpInsideAction(_ sender: Any) {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let appleRequest = appleIDProvider.createRequest()
        
        appleRequest.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [appleRequest])
        
        controller.delegate = appleLoginManager
        controller.presentationContextProvider = appleLoginManager
        controller.performRequests()
    }
}

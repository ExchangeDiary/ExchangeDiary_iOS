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
    
    @IBOutlet weak var googleLoginView: UIView!
    @IBOutlet weak var kakaoLoginView: UIView!
    @IBOutlet weak var appleLoginView: UIView!
    
    @IBOutlet weak var googleLoginButton: UIButton!
    @IBOutlet weak var kakaoLoginButton: UIButton!
    @IBOutlet weak var appleLoginButton: UIButton!
    
    let appleLoginManager = AppleLoginManager()
    let socialLoginManager = SocialLoginManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.googleLoginView.makeCircleView()
        self.kakaoLoginView.makeCircleView()
        self.appleLoginView.makeCircleView()
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
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [appleRequest])
        
        authorizationController.delegate = appleLoginManager
        authorizationController.presentationContextProvider = appleLoginManager
        authorizationController.performRequests()
    }
}

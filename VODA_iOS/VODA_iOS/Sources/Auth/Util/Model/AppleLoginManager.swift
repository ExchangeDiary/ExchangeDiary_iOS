//
//  AppleLoginManager.swift
//  VODA_iOS
//
//  Created by 조윤영 on 2021/08/04.
//

import AuthenticationServices

class AppleLoginManager: NSObject {
    weak var viewController: UIViewController?
}

extension AppleLoginManager: ASAuthorizationControllerPresentationContextProviding {
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return viewController!.view.window!
    }
}

extension AppleLoginManager: ASAuthorizationControllerDelegate {
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }
        
        let userIdentifier = appleIDCredential.user
        let userGivenName = appleIDCredential.fullName?.givenName
        let userFamilyName = appleIDCredential.fullName?.familyName
        let userName = "\(userFamilyName ?? "")\(userGivenName ?? "")"
        let userEmail = appleIDCredential.email
        
        guard let userIdentityToken = appleIDCredential.identityToken else { return }
        guard let userAuthorizationCode = appleIDCredential.authorizationCode else { return }
        let decodedUserToken = String(data: userIdentityToken, encoding: .utf8)
        let decodedUserAuthorizationCode = String(data: userAuthorizationCode, encoding: .utf8)
        
        print("userIdentifier:\(userIdentifier)")
        print("userName:\(String(describing: userName))")
        print("userEmail:\(String(describing: userEmail))")
        print("userToken:\(String(describing: decodedUserToken))")
        print("userAuthorizationCode:\(String(describing: decodedUserAuthorizationCode))")
    }
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {

    }
}

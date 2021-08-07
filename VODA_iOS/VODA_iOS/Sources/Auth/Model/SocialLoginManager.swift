//
//  SocialLoginManager.swift
//  VODA_iOS
//
//  Created by 조윤영 on 2021/08/07.
//

import KakaoSDKUser
import KakaoSDKAuth
import KakaoSDKCommon

class SocialLoginManager: NSObject {
    func login(with type: SocialLoginType) {
        switch type {
        case .kakao: self.loginWithKakao()
        case .google: self.loginWithGoogle()
        }
    }
    
    private func loginWithKakao() {
        if AuthApi.hasToken() {
            UserApi.shared.accessTokenInfo { _, error in
                if let error = error {
                    if let sdkError = error as? SdkError, sdkError.isInvalidTokenError() == true {
                        self.requestKakaoLogin()
                    } else {
                        print("sdk Error")
                    }
                } else {
                    print("has valid token, enter homepage")
                }
            }
        } else {
            self.requestKakaoLogin()
        }
    }
    
    private func requestKakaoLogin() {
        UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
            if let error = error {
                print(error)
            } else {
                print("loginWithKakaoAccount() success.")

                if let token = oauthToken?.accessToken {
                    print(token)
                }
                    
                self.requestUserInfo()
            }
        }
    }
    
    func requestUserInfo() {
        UserApi.shared.me { user, error in
            if let error = error {
                print(error)
            } else {
                let userName = user?.kakaoAccount?.profile?.nickname
                let userEmail = user?.kakaoAccount?.email
                let userImage = user?.kakaoAccount?.profile?.profileImageUrl
                
                print(userName ?? "")
                print(userEmail ?? "")
                print(userImage ?? "")
            }
        }
    }
    
    private func loginWithGoogle() {
        
    }
}

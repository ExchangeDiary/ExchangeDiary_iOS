//
//  LoginType.swift
//  VODA_iOS
//
//  Created by 조윤영 on 2021/08/07.
//

import Foundation

enum SocialLoginType {
    case kakao
    case google
    
    var appKey: String {
        switch self {
        case .kakao: return KeyValue.kakaoAppKey
        case .google: return KeyValue.googleAppKey
        }
    }
}

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
        case .kakao: return "526064c8965b822eaf28593b256a7e94"
        case .google: return "942019593044-ltgr599rqbogjp19n28u2583j9tnqfdv.apps.googleusercontent.com"
        }
    }
}

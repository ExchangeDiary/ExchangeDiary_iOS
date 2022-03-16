//
//  AuthorizationAPI.swift
//  VODA_iOS
//
//  Created by 조윤영 on 2022/03/14.
//

import Foundation
import Moya

enum AuthorizationAPI {
    case socialSignIn(authType: String, accessCode: String)
    case appleSignIn(authorizationCode: String, identityToken: String)
    case refreshToken(accessToken: String)
    case signOut(accessToken: String)
    case withDrawal(accessToken: String)
    case setProfile(nickName: String, profileImage: UIImage)
}

extension AuthorizationAPI: TargetType {
    var baseURL: URL {
        return URL(string: KeyValue.baseURL)!
    }
    
    var path: String {
        switch self {
        case .socialSignIn: return "/auth/socialSingnIn"
        case .appleSignIn: return "/auth/appleSignIn"
        case .refreshToken: return "/auth/refreshToken"
        case .signOut: return "/auth/signOut"
        case .withDrawal: return "/auth/withDrawl"
        case .setProfile: return "/api/profile"
        }
    }
    
    var method: Moya.Method {
         return .post
    }
  
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .signOut, .withDrawal:
            return .requestPlain
            
        case .socialSignIn(let authType, let accessCode):
            let parameters: [String: Any] = [
                "authType": authType,
                "accessCode": accessCode
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            
        case .appleSignIn(let authorizationCode, let identityToken):
            let parameters: [String: Any] = [
                "authorizationCode": authorizationCode,
                "identityToken": identityToken
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            
        case .refreshToken(let refreshToken):
            return .requestParameters(
                parameters: ["refreshToken": refreshToken],
                encoding: JSONEncoding.default
            )
            
        case .setProfile(let nickName, let profileImage):
            let nickNameData = MultipartFormData(provider: .data(nickName.data(using: .utf8)!), name: "nickName")
            let profileImageData = MultipartFormData(
                provider: .data(profileImage.jpegData(compressionQuality: 0.1)!),
                name: "profileImage")
            let multipartData = [nickNameData, profileImageData]
            return .uploadMultipart(multipartData)
        }
    }

    private var authorization: String {
        return "Bearer " + "token"
    }
    
    var headers: [String: String]? {
        switch self {
        case .appleSignIn, .socialSignIn:
            return ["Content-type": "application/json"]
        default:
            return [
                "Content-type": "application/json",
                "Authorization": ""
            ]
        }
    }
}

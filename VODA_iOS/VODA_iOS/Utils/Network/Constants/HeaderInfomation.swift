//
//  HeaderValue.swift
//  VODA_iOS
//
//  Created by 조윤영 on 2022/03/16.
//

import Foundation

enum HeaderInformation {
    enum HeaderKey {
        static let contentType = "Content-Type"
        static let authorization = "Authorization"
    }
    
    // TODO: tokenManager에서 값 뽑아서 삽입
    enum HeaderValue {
        static let json = "application/json"
        static let authoization = "Bearer " + "token"
    }
}

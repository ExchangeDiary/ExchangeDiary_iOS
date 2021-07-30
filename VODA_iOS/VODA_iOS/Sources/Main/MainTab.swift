//
//  MainTab.swift
//  VODA_iOS
//
//  Created by 전소영 on 2021/07/30.
//

import Foundation

enum MainTab {
    case push
    case home
    case myPage
    
    var segueIdentifier: String {
        switch self {
        case .push:
            return "PushSegue"
        case .home:
            return "HomeSegue"
        case .myPage:
            return "MyPageSegue"
        }
    }
    
    var index: Int {
        switch self {
        case .push:
            return 0
        case .home:
            return 1
        case .myPage:
            return 2
        }
    }
}

//
//  MainTab.swift
//  VODA_iOS
//
//  Created by 전소영 on 2021/07/30.
//

import Foundation

enum MainTab {
    case home
    case newDiary
    case myPage
    
    var segueIdentifier: String {
        switch self {
        case .home:
            return "HomeSegue"
        case .newDiary:
            return ""
        case .myPage:
            return "MyPageSegue"
        }
    }
    
    var index: Int {
        switch self {
        case .home:
            return 0
        case .newDiary:
            return 1
        case .myPage:
            return 2
        }
    }
}

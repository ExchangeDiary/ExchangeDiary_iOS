//
//  Storyboard.swift
//  VODA_iOS
//
//  Created by 전소영 on 2022/03/16.
//

import Foundation

enum Storyboard {
    case onBoarding
    case auth
    case main
    case home
    case newDiary
    case diary
    case writeStory
    case audioRecord
    case push
    case myPage
    case popUp
    case loading
    
    var name: String {
        switch self {
        case .onBoarding:
            return "OnBoarding"
        case .auth:
            return "Auth"
        case .main:
            return "Main"
        case .home:
            return "Home"
        case .newDiary:
            return "NewDiary"
        case .diary:
            return "Diary"
        case .writeStory:
            return "WriteStory"
        case .audioRecord:
            return "AudioRecord"
        case .push:
            return "Push"
        case .myPage:
            return "MyPage"
        case .popUp:
            return "PopUp"
        case .loading:
            return "Loading"
        }
    }
}

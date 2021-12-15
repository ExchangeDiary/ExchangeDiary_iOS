//
//  StoryDataResponse.swift
//  VODA_iOS
//
//  Created by 전소영 on 2021/12/15.
//

import Foundation

struct StoryDataResponse: Codable {
    let storyWriteDate: String
    let storyTitle: String
    let storyLocation: String
    let storyContentsText: String?
    let storyAudioTitle: String?
    let storyAudioFileName: String?
    let storyAudioPitch: Float?
    let storyAudioUrl: String?
    let storyPhotoUrl: String?
    let storyTemplete: Int?
}

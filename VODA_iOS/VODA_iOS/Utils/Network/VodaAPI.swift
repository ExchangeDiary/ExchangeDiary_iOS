//
//  VodaAPI.swift
//  VODA_iOS
//
//  Created by 전소영 on 2021/12/09.
//

import Foundation

import Moya

enum VodaAPI {
    case login(type: String, nickName: String, email: String, profileImage: Data)
    case setProfile(nickName: String, profileImage: Data)
    case createDiary(theme: String, name: String, period: Int, diaryCoverImage: Int, participationCode: String, codeHint: String)
    case getDiaryCoverImage
    case getDiary
    case getStory(diary: String)
    case getStoryDetail(index: Int)
    case setStoryWriteTurn(diary: String)
    case setStoryWritePeriod(diary: String)
    case setStoryParticipationCode(diary: String, code: String, hint: String)
    case writeStory(diary: String, storyData: StoryData)
    case setPush(deadLine: Bool, newStory: Bool)
    case getNotice
    case logout(token: String)
    case signOut(token: String)
    case testGetStoryDetail(index: Int)
}

extension VodaAPI: TargetType {
    var baseURL: URL {
        switch self {
        case .testGetStoryDetail:
            return URL(string: "https://raw.githubusercontent.com/ExchangeDiary/ExchangeDiary_iOS/3f287c57f5c42e89d6fad4aa7f7d4dd540e03dd8/VODA_iOS/VODA_iOS/Utils/Network/Mock/Mock.json")!
        default:
            return URL(string: "")!
        }
    }
    
    var path: String {
        switch self {
        case .login:
            return "/login"
        case .setProfile:
            return "/profile"
        case .createDiary:
            return "/diary"
        case .getDiaryCoverImage:
            return "/diaryCoverImage"
        case .getDiary:
            return "/diary"
        case .getStory:
            return "/story"
        case .getStoryDetail(let index):
            return "/story/\(index)"
        case .setStoryWriteTurn:
            return "/story/WriteTurn"
        case .setStoryWritePeriod:
            return "/story/WritePeriod"
        case .setStoryParticipationCode:
            return "/story/ParticipationCode"
        case .writeStory:
            return "/story"
        case .setPush:
            return "/push"
        case .getNotice:
            return "/notice"
        case .logout:
            return "/logout"
        case .signOut:
            return "/signOut"
        case .testGetStoryDetail:
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getDiaryCoverImage, .getDiary, .getStory, .getStoryDetail, .getNotice, .testGetStoryDetail:
            return .get
        case .login, .setProfile, .createDiary, .setStoryWriteTurn, .setStoryWritePeriod, .setStoryParticipationCode, .writeStory, .setPush, .logout, .signOut:
            return .post
        }
    }
  
    var sampleData: Data {
        switch self {
        case .testGetStoryDetail:
            return Data(
                """
                {
                    "storyWriteDate": "210102",
                    "storyTitle": "testTitle",
                    "storyLocation": "home",
                    "storyContentsText": "testText",
                    "storyAudioTitle": "testAudioTitle",
                    "storyAudioFileName": "testFileName",
                    "storyAudioPitch": 0.5,
                    "storyAudioUrl": "https://github.com/ExchangeDiary/ExchangeDiary_iOS",
                    "storyPhotoUrl": "https://github.com/ExchangeDiary/ExchangeDiary_iOS",
                    "storyTemplete": 1,
                }
                """.utf8
            )
        default:
            return Data()
        }
    }
    
    var task: Task {
        switch self {
        case .login(let type, let nickName, let email, let profileImage):
            let typeData = MultipartFormData(provider: .data(type.data(using: .utf8)!), name: "type")
            let nickNameData = MultipartFormData(provider: .data(nickName.data(using: .utf8)!), name: "nickName")
            let emailData = MultipartFormData(provider: .data(email.data(using: .utf8)!), name: "email")
            let profileImageData = MultipartFormData(provider: .data(profileImage), name: "profileImage", fileName: "image.png", mimeType: "image/png")
            let multipartData = [typeData, nickNameData, emailData, profileImageData]
            return .uploadMultipart(multipartData)
        case .setProfile(let nickName, let profileImage):
            let nickNameData = MultipartFormData(provider: .data(nickName.data(using: .utf8)!), name: "nickName")
            let profileImageData = MultipartFormData(provider: .data(profileImage), name: "profileImage", fileName: "image.png", mimeType: "image/png")
            let multipartData = [nickNameData, profileImageData]
            return .uploadMultipart(multipartData)
        case .createDiary(let theme, let name, let period, let diaryCoverImage, let participationCode, let codeHint):
            return .requestParameters(parameters: ["theme": theme,
                                                   "name": name,
                                                   "period": period,
                                                   "diaryCoverImage": diaryCoverImage,
                                                   "participationCode": participationCode,
                                                   "codeHint": codeHint
                                                  ], encoding: JSONEncoding.default)
        case .getDiaryCoverImage, .getDiary, .getNotice:
            return .requestPlain
        case .getStory(let diary):
            return .requestParameters(parameters: ["diary": diary], encoding: JSONEncoding.default)
        case .getStoryDetail(let index):
            return .requestParameters(parameters: ["index": index], encoding: URLEncoding.queryString)
        case .setStoryWriteTurn(let diary), .setStoryWritePeriod(let diary):
            return .requestParameters(parameters: ["diary": diary], encoding: JSONEncoding.default)
        case .setStoryParticipationCode(let diary, let code, let hint):
            return .requestParameters(parameters: ["diary": diary,
                                                   "code": code,
                                                   "hint": hint], encoding: JSONEncoding.default)
        case .writeStory(let diary, let storyData):
            let diaryData = MultipartFormData(provider: .data(diary.data(using: .utf8)!), name: "diary")
            let storyLocationData = MultipartFormData(provider: .data(storyData.storyLocation.data(using: .utf8)!), name: "storyLocation")
            let storyTitleData = MultipartFormData(provider: .data(storyData.storyTitle.data(using: .utf8)!), name: "storyTitle")
            let storyContentsData = MultipartFormData(provider: .data(storyData.storyContentsText!.data(using: .utf8)!), name: "storyContents")
            let storyTempleteData = MultipartFormData(provider: .data(String(storyData.storyTemplete!).data(using: .utf8)!), name: "storyTemplete")
            let storyAudioTitleData = MultipartFormData(provider: .data(storyData.storyAudioTitle!.data(using: .utf8)!), name: "storyAudioTitle")
            let storyAudioPitchData = MultipartFormData(provider: .data(String(storyData.storyAudioPitch!).data(using: .utf8)!), name: "storyAudioPitch")
            let storyAudioData = MultipartFormData(provider: .data(storyData.storyAudioData!), name: "storyAudioData", fileName: "\(String(describing: storyData.storyAudioFileName)).mp4", mimeType: "audio/mp4")
            let storyPhotoImageData = MultipartFormData(provider: .data(storyData.storyPhotoImage!.jpegData(compressionQuality: 0.5)!), name: "storyPhotoImage", fileName: "image.png", mimeType: "image/png")
            let multipartData = [diaryData, storyLocationData, storyTitleData, storyContentsData, storyTempleteData, storyAudioTitleData, storyAudioPitchData, storyAudioData, storyPhotoImageData]
            return .uploadMultipart(multipartData)
        case .setPush(let deadLine, let newStory):
            return .requestParameters(parameters: ["deadLine": deadLine,
                                                   "newStory": newStory], encoding: JSONEncoding.default)
        case .logout(let token), .signOut(let token):
            return .requestParameters(parameters: ["token": token], encoding: JSONEncoding.default)
        case .testGetStoryDetail(let index):
            return .requestParameters(parameters: ["index": index], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .login, .testGetStoryDetail:
            return nil
        default:
            return ["Content-type": "application/json",
                    "token": ""]
        }
    }
}

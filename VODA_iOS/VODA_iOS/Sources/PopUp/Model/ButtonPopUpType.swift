//
//  ButtonPopUpType.swift
//  VODA_iOS
//
//  Created by 전소영 on 2021/08/13.
//

import Foundation

enum ButtonPopUpType {
    case emailCheck
    case outRoom
    case completeWriteStory
    case checkStoryContentNil
    case checkStoryLocationTitleNil
    case noSaveStory
    case reRecord
    case networkError
    case serverError
    case logout
    case withdrawal
    
    var message: String {
        switch self {
        case .emailCheck:
            return "이미 가입된 이메일 계정입니다."
        case .outRoom:
            return "다이어리 방을 나가면\n활동 내용이 모두 삭제됩니다."
        case .completeWriteStory:
            return "교환 일기 작성이 완료되었어요!\n지금 바로 확인해보세요:)"
        case .checkStoryContentNil:
            return "음성 혹은 텍스트 중 하나 이상\n작성해야 일기 등록이 가능해요."
        case .checkStoryLocationTitleNil:
            return "장소와 제목을 작성해야\n일기 등록이 가능해요."
        case .noSaveStory:
            return "페이지를 벗어나면\n작성한 내용은 저장되지 않아요.\n그래도 나가시겠어요?"
        case .reRecord:
            return "새로운 음성을 \n녹음하시겠어요?"
        case .networkError:
            return "네트워크가 불안정하여 접속이\n원활하지 않습니다.\n잠시 후 다시 시도해 주세요."
        case .serverError:
            return "서버 오류가 발생하였습니다.\n이전 화면으로 돌아가거나\n앱을 다시 실행해 주세요."
        case .logout:
            return "정말 로그아웃 하시겠습니까?"
        case .withdrawal:
            return "회원 탈퇴와 함께 VODA에\n등록된 모든 정보는 삭제, 폐기\n처리되며 복구되지 않습니다."
        }
    }
  
    var numberOfButton: Int? {
        switch self {
        case .completeWriteStory, .checkStoryContentNil, .checkStoryLocationTitleNil, .networkError, .serverError:
            return 1
        case .emailCheck, .outRoom, .noSaveStory, .reRecord, .logout, .withdrawal:
            return 2
        }
    }
    
    var confirmButtonTitle: String {
        switch self {
        case .completeWriteStory:
            return "바로가기"
        case .serverError:
            return "돌아가기"
        case .logout:
            return "로그아웃"
        case .withdrawal:
            return "탈퇴하기"
        default:
            return "확인"
        }
    }
    
    var labelTopConstraint: Float? {
        let popUpViewHeight = Float(DeviceInfo.screenHeight * 0.2216)
        
        switch self {
        case .logout, .emailCheck:
            return popUpViewHeight * 0.3055
        case .outRoom,.completeWriteStory, .checkStoryContentNil, .checkStoryLocationTitleNil, .reRecord:
            return popUpViewHeight * 0.2222
        case .noSaveStory, .networkError, .serverError, .withdrawal:
            return popUpViewHeight * 0.1444
        }
    }
}

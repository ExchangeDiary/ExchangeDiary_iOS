//
//  AudioPlayerError.swift
//  VODA_iOS
//
//  Created by 전소영 on 2021/08/11.
//

import Foundation

public enum AudioPlayerError: Error {
    case audioFileError
    case audioEngineError
    case audioManualRenderingModeError
    case audioPlayerError
    
    var message: String {
        switch self {
        case .audioFileError:
            return "Audio File Error"
        case .audioEngineError:
            return "Audio Engine Error"
        case .audioManualRenderingModeError:
            return "Audio Manual Rendering Mode Error"
        case .audioPlayerError:
            return "Audio Player Error"
        }
    }
}

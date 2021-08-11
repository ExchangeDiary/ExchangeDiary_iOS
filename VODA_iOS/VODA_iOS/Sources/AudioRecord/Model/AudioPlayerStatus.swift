//
//  AudioPlayerStatus.swift
//  VODA_iOS
//
//  Created by 전소영 on 2021/08/11.
//

import Foundation

public enum AudioPlayerStatus: String {
    case idle
    case prepared
    case playing
    case paused
    case stopped
    case errorOccured
}

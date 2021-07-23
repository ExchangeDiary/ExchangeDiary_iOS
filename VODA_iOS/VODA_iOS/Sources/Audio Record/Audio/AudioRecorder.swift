//
//  AudioRecorder.swift
//  VODA_iOS
//
//  Created by 전소영 on 2021/07/23.
//

import Foundation

enum AudioRecorderState: String {
  case prepared = "prepared"
  case record = "record"
  case stopped = "stopped"
  case errorOccured = "errorOccured"
}

protocol AudioRecordDelegate {
    func AudioRecorder(_ audioPlayer: AudioRecorder, stateChanged state: AudioRecorderState)
    func AudioRecorder(_ audioPlayer: AudioRecorder, stateErrorOccured state: AudioRecorderState)
}

class AudioRecorder {
    var delegate: AudioRecordDelegate?
    
    var state: AudioRecorderState = .prepared {
        didSet {
            delegate?.AudioRecorder(self, stateChanged: state)
        }
    }
    
    func record() {
        state = .record
        print("녹음합니다.")
        
    }
   
    func stop() {
        state = .stopped
        print("정지합니다.")
        
    }
    
    
}

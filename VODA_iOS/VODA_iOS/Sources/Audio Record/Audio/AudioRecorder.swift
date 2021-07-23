//
//  AudioRecorder.swift
//  VODA_iOS
//
//  Created by 전소영 on 2021/07/23.
//

import Foundation
import AVFoundation

extension Notification.Name {
    static let finishRecord = Notification.Name("finishRecord")
}

enum AudioRecorderState: String {
  case prepared = "prepared"
  case record = "record"
  case stopped = "stopped"
  case errorOccured = "errorOccured"
}

protocol AudioRecordDelegate {
    func AudioRecorder(_ audioPlayer: AudioRecorder, stateChanged state: AudioRecorderState)
    func AudioRecorder(_ audioPlayer: AudioRecorder, stateErrorOccured state: AudioRecorderState)
    func AudioRecorder(_ audioPlayer: AVAudioRecorder, didFinishedWithURL url: URL?)
    func AudioRecorder(_ audioPlayer: AVAudioRecorder, currentTime: String)
}

class AudioRecorder: NSObject {
    var audioRecorder: AVAudioRecorder?
    var recordTimer: Timer?
    var recordTimeLimitTimer: Timer?
    var delegate: AudioRecordDelegate?
    static let shared = AudioRecorder()
    
    var state: AudioRecorderState = .prepared {
        didSet {
            delegate?.AudioRecorder(self, stateChanged: state)
        }
    }
    
    private override init() {
        
    }
    
    func record() {
        state = .record
        print("녹음합니다.")
        
        let directoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        print(directoryPath)
        let recordingName = "recordedVoice.m4a"
        
        let pathArray = [directoryPath, recordingName]
        guard let filePath = URL(string: pathArray.joined(separator: "/")) else {
            return
        }
        print(filePath)
        
        let recordSettings = [AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue,
                              AVEncoderBitRateKey: 32,
                              AVNumberOfChannelsKey: 1,
                              AVSampleRateKey: 12000] as [String : Any]
        
        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(AVAudioSession.Category.playAndRecord, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        
        try? audioRecorder = AVAudioRecorder(url: filePath, settings: recordSettings)
        
        audioRecorder?.delegate = self
        audioRecorder?.isMeteringEnabled = true
        audioRecorder?.prepareToRecord()
        audioRecorder?.record()
        
        addTimer()
    }
   
    @objc func stop() {
        state = .stopped
        print("정지합니다.")
        
        recordTimer?.invalidate()
        audioRecorder?.stop()
        
        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setActive(false)
    }
    
    @objc func getCurrentTime() {
        guard let audioRecorder = audioRecorder else {
            return
        }
        let currentTime = audioRecorder.currentTime
        
        delegate?.AudioRecorder(audioRecorder, currentTime: currentTime.stringFromTimeInterval())
    }
    
    func addTimer() {
        recordTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(getCurrentTime), userInfo: nil, repeats: true)
        
        recordTimeLimitTimer = Timer.scheduledTimer(timeInterval: 30.0, target: self, selector: #selector(stop), userInfo: nil, repeats: false)
    }
}

// MARK: AVAudioRecorderDelegate
extension AudioRecorder: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            delegate?.AudioRecorder(recorder, didFinishedWithURL: audioRecorder?.url)
            NotificationCenter.default.post(name: Notification.Name.finishRecord, object: nil)
        } else {
            print("recording was not succesful")
        }
    }
}
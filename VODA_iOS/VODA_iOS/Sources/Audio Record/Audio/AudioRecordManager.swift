//
//  AudioRecordManager.swift
//  VODA_iOS
//
//  Created by 전소영 on 2021/07/23.
//

import Foundation
import AVFoundation

extension Notification.Name {
    static let finishRecord = Notification.Name("finishRecord")
}

enum AudioRecordState: String {
    case prepared = "prepared"
    case record = "record"
    case stopped = "stopped"
    case errorOccured = "errorOccured"
}

protocol AudioRecordDelegate {
    func AudioRecorder(_ audioPlayer: AudioRecordManager, stateChanged state: AudioRecordState)
    func AudioRecorder(_ audioPlayer: AudioRecordManager, stateErrorOccured state: AudioRecordState)
    func AudioRecorder(_ audioPlayer: AudioRecordManager, currentTime: String)
}

class AudioRecordManager: NSObject {
    var audioRecorder: AVAudioRecorder?
    var recordTimer: Timer?
    var recordTimeLimitTimer: Timer?
    var delegate: AudioRecordDelegate?
    static let shared = AudioRecordManager()
    
    var state: AudioRecordState = .prepared {
        didSet {
            delegate?.AudioRecorder(self, stateChanged: state)
        }
    }
    
    private override init() { }
    
    func record() {
        state = .record
        
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
        
        delegate?.AudioRecorder(self, currentTime: currentTime.stringFromTimeInterval())
    }
    
    func addTimer() {
        recordTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(getCurrentTime), userInfo: nil, repeats: true)
        
        recordTimeLimitTimer = Timer.scheduledTimer(timeInterval: 30.0, target: self, selector: #selector(stop), userInfo: nil, repeats: false)
    }
}

// MARK: AVAudioRecorderDelegate
extension AudioRecordManager: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            NotificationCenter.default.post(name: Notification.Name.finishRecord, object: nil, userInfo: ["audioRecoderUrl" : audioRecorder?.url])
        } else {
            print("recording was not succesful")
        }
    }
}

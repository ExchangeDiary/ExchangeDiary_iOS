//
//  VodaAudioRecorder.swift
//  VODA_iOS
//
//  Created by 전소영 on 2021/07/23.
//

import Foundation
import AVFoundation
//FIXME: enum 파일 분리, class명 변경
enum AudioRecordStatus {
    case idle
    case prepared
    case record
    case stopped
    case errorOccured
}

protocol AudioRecordable: AnyObject {
    func audioRecorder(_ audioPlayer: VodaAudioRecorder, statusChanged status: AudioRecordStatus)
    func audioRecorder(_ audioPlayer: VodaAudioRecorder, statusErrorOccured status: AudioRecordStatus)
    func audioRecorder(_ audioPlayer: VodaAudioRecorder, didFinishedWithUrl url: URL?)
    func audioRecorder(_ audioPlayer: VodaAudioRecorder, currentTime: TimeInterval)
}

class VodaAudioRecorder: NSObject {
    private var audioRecorder: AVAudioRecorder?
    private var recordTimer: Timer?
    public var currentTime: TimeInterval? {
        audioRecorder?.currentTime
    }
    //FIXME: 변수 public, extension
    weak var delegate: AudioRecordable?
    static let shared = VodaAudioRecorder()
    let audioSession = AVAudioSession.sharedInstance()
    
    var status: AudioRecordStatus = .idle {
        didSet {
            delegate?.audioRecorder(self, statusChanged: status)
        }
    }
    
    private override init() { }
    
    public func record() {
        guard let directoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else {
            return
        }
        print(directoryPath)
        let recordingName = "recordedVoice.m4a"
        guard let filePath = URL(string: [directoryPath, recordingName].joined(separator: "/")) else {
            return
        }
        print(filePath)
        
        let recordSettings: [String: Any] = [AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue,
                                             AVEncoderBitRateKey: 32,
                                             AVNumberOfChannelsKey: 1,
                                             AVSampleRateKey: 12000]
        
        do {
            try? audioSession.setCategory(.playAndRecord, options: [.allowBluetooth,.defaultToSpeaker])
            
            try? audioRecorder = AVAudioRecorder(url: filePath, settings: recordSettings)
            audioRecorder?.delegate = self
            
            try? audioSession.setActive(true)
            audioRecorder?.isMeteringEnabled = true
            audioRecorder?.prepareToRecord()
            
            status = .prepared
            
            audioRecorder?.record()
            addTimer()
            
            status = .record
        } catch {
            print(error.localizedDescription.description)
        }
    }
    
    public func stop() {
        status = .stopped
        
        recordTimer?.invalidate()
        audioRecorder?.stop()
        
        try? audioSession.setActive(false)
    }
    
    @objc private func getCurrentTime() {
        if let currentTime = currentTime {
            if currentTime >= 30.0 {
                stop()
            }
            delegate?.audioRecorder(self, currentTime: currentTime)
        }
    }
    
    private func addTimer() {
        recordTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(getCurrentTime), userInfo: nil, repeats: true)
    }
}

// MARK: AVAudioRecorderDelegate
extension VodaAudioRecorder: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            delegate?.audioRecorder(self, didFinishedWithUrl: audioRecorder?.url)
        } else {
            print("recording was not succesful")
        }
    }
}

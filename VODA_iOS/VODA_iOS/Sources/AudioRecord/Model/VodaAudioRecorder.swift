//
//  VodaAudioRecorder.swift
//  VODA_iOS
//
//  Created by 전소영 on 2021/07/23.
//

import Foundation
import AVFoundation

public protocol AudioRecordable: AnyObject {
    func audioRecorder(_ audioPlayer: VodaAudioRecorder, didChangedStatus status: AudioRecordStatus)
    func audioRecorder(_ audioPlayer: VodaAudioRecorder, didFinishedWithUrl url: URL?)
    func audioRecorder(_ audioPlayer: VodaAudioRecorder, didUpdateCurrentTime currentTime: TimeInterval)
}

public class VodaAudioRecorder: NSObject {
    private var audioRecorder: AVAudioRecorder?
    private var recordTimer: Timer?
    private let audioSession = AVAudioSession.sharedInstance()
   
    public static let shared = VodaAudioRecorder()
    public weak var delegate: AudioRecordable?
    
    public var currentTime: TimeInterval {
        audioRecorder?.currentTime ?? 0
    }
    
    public var status: AudioRecordStatus = .idle {
        didSet {
            delegate?.audioRecorder(self, didChangedStatus: status)
        }
    }
    
    private override init() { }
    
    @objc private func getCurrentTime() {
        delegate?.audioRecorder(self, didUpdateCurrentTime: currentTime)
        
        let isReachedToMaxTime = currentTime >= 30.0
        if isReachedToMaxTime {
            stop()
        }
    }
    
    private func addTimer() {
        recordTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(getCurrentTime), userInfo: nil, repeats: true)
    }
}

// MARK: public
extension VodaAudioRecorder {
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
            try? audioSession.setCategory(.playAndRecord, options: [.allowBluetooth, .defaultToSpeaker])
            
            try? audioRecorder = AVAudioRecorder(url: filePath, settings: recordSettings)
            audioRecorder?.delegate = self
            
            try? audioSession.setActive(true)
            audioRecorder?.isMeteringEnabled = true
            audioRecorder?.prepareToRecord()
            
            status = .prepared
            
            audioRecorder?.record()
            addTimer()
            
            status = .recording
        } catch {
            print(error.localizedDescription.description)
        }
    }
    
    public func stop() {
        recordTimer?.invalidate()
        audioRecorder?.stop()
        
        try? audioSession.setActive(false)
        
        status = .stopped
    }
}

// MARK: AVAudioRecorderDelegate
extension VodaAudioRecorder: AVAudioRecorderDelegate {
    public func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            delegate?.audioRecorder(self, didFinishedWithUrl: audioRecorder?.url)
        } else {
            print("recording was not succesful")
        }
    }
}

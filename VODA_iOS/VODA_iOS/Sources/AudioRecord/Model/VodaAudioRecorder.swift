//
//  VodaAudioRecorder.swift
//  VODA_iOS
//
//  Created by 전소영 on 2021/07/23.
//

import Foundation
import AVFoundation

public protocol AudioRecordable: AnyObject {
    func audioRecorder(_ audioRecorder: VodaAudioRecorder, didChangedStatus status: AudioRecordStatus)
    func audioRecorder(_ audioRecorder: VodaAudioRecorder, didFinishedWithUrl url: URL?, didFinishedWithRecordingFileName recordingFileName: String)
    func audioRecorder(_ audioRecorder: VodaAudioRecorder, didUpdateCurrentTime currentTime: TimeInterval)
    func audioRecorder(_ audioRecorder: VodaAudioRecorder, didUpdateDecibel decibel: Float)
}

public class VodaAudioRecorder: NSObject {
    private var audioRecorder: AVAudioRecorder?
    private var recordTimer: Timer?
    private let audioSession = AVAudioSession.sharedInstance()
    private var recordingName = ""
   
    public static let shared = VodaAudioRecorder()
    public weak var delegate: AudioRecordable?
    
    public var currentTime: TimeInterval {
        audioRecorder?.currentTime ?? 0
    }
    
    public var averageDecibel: Float? {
        audioRecorder?.averagePower(forChannel: 0)
    }
    
    public var status: AudioRecordStatus = .idle {
        didSet {
            delegate?.audioRecorder(self, didChangedStatus: status)
        }
    }
    
    private override init() {
        audioRecorder?.isMeteringEnabled = true
    }
    
    @objc private func getCurrentTime() {
        delegate?.audioRecorder(self, didUpdateCurrentTime: currentTime)
        
        audioRecorder?.updateMeters()
        
        guard let decibel = averageDecibel else {
            return
        }
        
        delegate?.audioRecorder(self, didUpdateDecibel: normalizeDecibelLevel(from: decibel))
        
        let isReachedToMaxTime = currentTime >= 30.0
        if isReachedToMaxTime {
            stop()
        }
    }
   
    private func addTimer() {
        recordTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(getCurrentTime), userInfo: nil, repeats: true)
    }
    
    private func normalizeDecibelLevel(from decibel: Float) -> Float {
        if decibel < -60.0 || decibel == 0.0 {
            return 0.0
        }
        
        return powf((powf(10.0, 0.05 * decibel) - powf(10.0, 0.05 * -60.0)) * (1.0 / (1.0 - powf(10.0, 0.05 * -60.0))), 1.0 / 2.0) * 10
    }
}

// MARK: public
extension VodaAudioRecorder {
    public func record() {
        guard let directoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else {
            return
        }
        print(directoryPath)
        recordingName = "\(UUID()).mp4"
        
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
            delegate?.audioRecorder(self, didFinishedWithUrl: audioRecorder?.url, didFinishedWithRecordingFileName: recordingName)
        } else {
            print("recording was not succesful")
        }
    }
}

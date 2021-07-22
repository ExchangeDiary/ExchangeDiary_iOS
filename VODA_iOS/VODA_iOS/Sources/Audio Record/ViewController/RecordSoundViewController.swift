//
//  RecordSoundViewController.swift
//  VODA_iOS
//
//  Created by 전소영 on 2021/07/22.
//

import UIKit
import AVFoundation

class RecordSoundViewController: UIViewController {
    @IBOutlet weak var recordTime: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordGuideText: UILabel!
    private var audioRecorder: AVAudioRecorder?
    private var recordTimer: Timer?
    private var recordTimeLimitTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func recordAudio(_ sender: Any) {
        recordButton.setImage(UIImage(named: "stop"), for: .normal)
        recordGuideText.isHidden = true
        
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
        
        recordTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateRecordTime), userInfo: nil, repeats: true)
        
        recordTimeLimitTimer = Timer.scheduledTimer(timeInterval: 30.0, target: self, selector: #selector(stopRecording), userInfo: nil, repeats: false)
    }
    
    @objc func updateRecordTime() {
        guard let currentTime = audioRecorder?.currentTime else {
            return
        }
        
        recordTime.text = currentTime.stringFromTimeInterval()
    }
    
    @objc func stopRecording() {
        recordTimer?.invalidate()
        audioRecorder?.stop()
        
        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setActive(false)
    }
}

// MARK: AVAudioRecorderDelegate
extension RecordSoundViewController: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder?.url)
        } else {
            print("recording was not succesful")
        }
    }
}

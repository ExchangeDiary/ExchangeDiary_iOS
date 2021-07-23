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
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordGuideText: UILabel!
    var recordState: String?
    var recordedAudioURL: URL?
    var audioRecorder: AudioRecordManager?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundViewController = segue.destination as? PlaySoundViewController
            playSoundViewController?.recordedAudioURL = recordedAudioURL
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopButton.isHidden = true
        
        audioRecorder = AudioRecordManager.shared
        audioRecorder?.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(finishRecord), name: Notification.Name.finishRecord, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        stopButton.isHidden = true
    }
    
    @IBAction func recordAudio(_ sender: Any) {
        recordButton.isHidden = true
        recordGuideText.isHidden = true
        stopButton.isHidden = false
        
        audioRecorder?.record()
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        audioRecorder?.stop()
    }
    
    @objc func finishRecord(_ notification: Notification) {
        performSegue(withIdentifier: "stopRecording", sender: recordedAudioURL)
        
        guard let recordedurl = notification.userInfo?["audioRecoderUrl"] as? URL else {
            return
        }
        recordedAudioURL = recordedurl
        print("recordedAudioURL: \(recordedurl)")
    }
}

// Mark: AudioRecordDelegate
extension RecordSoundViewController: AudioRecordDelegate {
    func AudioRecorder(_ audioPlayer: AudioRecordManager, stateChanged state: AudioRecordState) {
        recordState = state.rawValue
        print("recordState: \(recordState)")
    }
    
    func AudioRecorder(_ audioPlayer: AudioRecordManager, stateErrorOccured state: AudioRecordState) {
        print("error occured")
    }
    
    func AudioRecorder(_ audioPlayer: AudioRecordManager, currentTime: String) {
        recordTime.text = currentTime
    }
}

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
    
    var recordStatus: String?
    var recordedAudioUrl: URL?
    var audioRecorder: AudioRecordManager?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifier.stopRecording {
            let playSoundViewController = segue.destination as? PlaySoundViewController
            playSoundViewController?.recordedAudioUrl = recordedAudioUrl
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopButton.isHidden = true
        
        audioRecorder = AudioRecordManager.shared
        audioRecorder?.delegate = self
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
}

// Mark: AudioRecordDelegate
extension RecordSoundViewController: AudioRecordManagerDelegate {
    func audioRecorder(_ audioPlayer: AudioRecordManager, didFinishedWithUrl url: URL?) {
        guard let recordedUrl = url else {
            return
        }
        recordedAudioUrl = recordedUrl
        print("recordedAudioURL: \(recordedUrl)")
    }
    
    func audioRecorder(_ audioPlayer: AudioRecordManager, statusChanged status: AudioRecordStatus) {
        if status == .finished {
            performSegue(withIdentifier: SegueIdentifier.stopRecording, sender: self)
        }
        print("recordState: \(status)")
    }
    
    func audioRecorder(_ audioPlayer: AudioRecordManager, statusErrorOccured status: AudioRecordStatus) {
        print("error occured")
    }
    
    func audioRecorder(_ audioPlayer: AudioRecordManager, currentTime: String) {
        recordTime.text = currentTime
    }
}

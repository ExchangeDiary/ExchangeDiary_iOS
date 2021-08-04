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
    
    var recordedAudioUrl: URL?
    var audioRecorder: AudioRecordManager?
    var recordStatus: AudioRecordStatus?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifier.stopRecording {
            let playSoundViewController = segue.destination as? PlaySoundViewController
            playSoundViewController?.recordedAudioUrl = recordedAudioUrl
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpRecordButtonUI(.idle)
        
        audioRecorder = AudioRecordManager.shared
        audioRecorder?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        recordTime.text = "00 : 00"
    }
    
    @IBAction func recordAudio(_ sender: Any) {
        audioRecorder?.record()
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        audioRecorder?.stop()
    }
    
    func setUpRecordButtonUI(_ recordStatus: AudioRecordStatus) {
        switch recordStatus {
        case .idle, .prepared:
            stopButton.isHidden = true
        case .record:
            recordButton.isHidden = true
            recordGuideText.isHidden = true
            stopButton.isHidden = false
        case .stopped:
            stopButton.isHidden = true
            recordButton.isHidden = false
            recordGuideText.isHidden = false
        default:
            break
        }
    }
}

// Mark: AudioRecordDelegate
extension RecordSoundViewController: AudioRecordable {
    func audioRecorder(_ audioPlayer: AudioRecordManager, didFinishedWithUrl url: URL?) {
        guard let recordedUrl = url else {
            return
        }
        recordedAudioUrl = recordedUrl
        print("recordedAudioURL: \(recordedUrl)")
        
        performSegue(withIdentifier: SegueIdentifier.stopRecording, sender: self)
    }
    
    func audioRecorder(_ audioPlayer: AudioRecordManager, statusChanged status: AudioRecordStatus) {
        print("recordStatus: \(status)")
        setUpRecordButtonUI(status)
    }
    
    func audioRecorder(_ audioPlayer: AudioRecordManager, statusErrorOccured status: AudioRecordStatus) {
        print("error occured")
    }
    
    func audioRecorder(_ audioPlayer: AudioRecordManager, currentTime: String) {
        recordTime.text = currentTime
    }
}

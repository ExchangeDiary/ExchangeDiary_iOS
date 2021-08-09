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
    private var audioRecorder: VodaAudioRecorder?
    private var recordStatus: AudioRecordStatus?
    private var recordedAudioUrl: URL?
    var recordedDuration: TimeInterval?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifier.stopRecording {
            let playSoundViewController = segue.destination as? PlaySoundViewController
            playSoundViewController?.recordedAudioUrl = recordedAudioUrl
            playSoundViewController?.playDuration = recordedDuration
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRecordButtonUI(.idle)
        
        audioRecorder = VodaAudioRecorder.shared
        audioRecorder?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        recordTime.text = "00 : 00"
    }
    
    private func setupRecordButtonUI(_ recordStatus: AudioRecordStatus) {
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
    
    @IBAction func recordAudio(_ sender: Any) {
        audioRecorder?.record()
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        recordedDuration = audioRecorder?.currentTime
        audioRecorder?.stop()
    }
}

// Mark: AudioRecordable
extension RecordSoundViewController: AudioRecordable {
    func audioRecorder(_ audioPlayer: VodaAudioRecorder, didFinishedWithUrl url: URL?) {
        guard let recordedUrl = url else {
            return
        }
        recordedAudioUrl = recordedUrl
        print("recordedAudioURL: \(recordedUrl)")
        
        performSegue(withIdentifier: SegueIdentifier.stopRecording, sender: self)
    }
    
    func audioRecorder(_ audioPlayer: VodaAudioRecorder, statusChanged status: AudioRecordStatus) {
        print("recordStatus: \(status)")
        setupRecordButtonUI(status)
    }
    
    func audioRecorder(_ audioPlayer: VodaAudioRecorder, statusErrorOccured status: AudioRecordStatus) {
        print("error occured")
    }
    
    func audioRecorder(_ audioPlayer: VodaAudioRecorder, currentTime: TimeInterval) {
        recordTime.text = currentTime.stringFromTimeInterval()
        recordedDuration = currentTime
    }
}

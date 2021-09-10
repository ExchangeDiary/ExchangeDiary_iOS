//
//  RecordSoundViewController.swift
//  VODA_iOS
//
//  Created by 전소영 on 2021/07/22.
//

import UIKit
import AVFoundation
import SoundWave

class RecordSoundViewController: UIViewController {
    @IBOutlet weak var voiceRecordTitleLabel: UILabel!
    @IBOutlet weak var recordTimeLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordGuideTextLabel: UILabel!
    private var audioRecorder = VodaAudioRecorder.shared
    private var recordStatus: AudioRecordStatus?
    private var recordedAudioUrl: URL?
    private var audioWaveView: AudioVisualizationView?
    var recordedDuration: TimeInterval?
    var completionHandler: ((AudioData) -> Void)?
    
    private let rightBarButton: UIButton = {
        let rightBarButton = UIButton(frame: CGRect(x: 0, y: 0, width: DeviceInfo.screenWidth * 0.16266, height: DeviceInfo.screenHeight * 0.04802))
        
        rightBarButton.backgroundColor = UIColor.CustomColor.vodaGray4
        rightBarButton.setTitle("완료", for: .normal)
        rightBarButton.titleLabel?.font = UIFont(name: "Apple SD Gothic Neo", size: 14)
        rightBarButton.layer.cornerRadius = 8
        
        return rightBarButton
    }()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifier.stopRecording {
            let playSoundViewController = segue.destination as? PlaySoundViewController
            playSoundViewController?.recordedAudioUrl = recordedAudioUrl
            playSoundViewController?.playDuration = recordedDuration
            playSoundViewController?.recordingTitle = "Untitle_\(getCurrentDate())"
            playSoundViewController?.completionHandler = completionHandler
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBarUI()
        setUpRecordButtonUI(.idle)
        
        audioRecorder.delegate = self
        
        (rootViewController as? MainViewController)?.setTabBarHidden(true)
        
        voiceRecordTitleLabel.text = "Untitle_\(getCurrentDate())"
        
        setAudioWaveViewUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        recordTimeLabel.text = "00:00"
    }
    
    private func setUpNavigationBarUI() {
        self.setNavigationBarTransparency()
        self.setBackButton(color: .black)
        
        let rightBarButtonItem = UIBarButtonItem(customView: rightBarButton)
        self.navigationItem.setRightBarButtonItems([rightBarButtonItem], animated: false)
    }
    
    private func setUpRecordButtonUI(_ recordStatus: AudioRecordStatus) {
        switch recordStatus {
        case .idle, .prepared:
            stopButton.isHidden = true
        case .recording:
            recordButton.isHidden = true
            recordGuideTextLabel.isHidden = true
            stopButton.isHidden = false
        case .stopped:
            stopButton.isHidden = true
            recordButton.isHidden = false
            recordGuideTextLabel.isHidden = false
        default:
            break
        }
    }
    
    private func setAudioWaveViewUI() {
        audioWaveView = AudioVisualizationView(frame: CGRect(x: 0, y: 0, width: DeviceInfo.screenWidth, height: DeviceInfo.screenHeight * 0.2))
        
        if let audioVisualizationView = audioWaveView {
            audioVisualizationView.center.y = recordButton.center.y + (recordButton.bounds.height * 0.5)
            audioVisualizationView.backgroundColor = .clear
            audioVisualizationView.gradientStartColor = UIColor.CustomColor.vodaMainBlue
            audioVisualizationView.gradientEndColor = UIColor.CustomColor.vodaMainBlue
            audioVisualizationView.audioVisualizationMode = .write
            view.insertSubview(audioVisualizationView, at: 0)
        }
    }
    
    private func getCurrentDate() -> String {
        let nowDate = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyMMdd"
        
        let currentDate = dateFormatter.string(from: nowDate)
        
        return currentDate
    }
    
    @IBAction func recordAudio(_ sender: Any) {
        audioRecorder.record()
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        recordedDuration = audioRecorder.currentTime
        audioRecorder.stop()
        
        audioWaveView?.reset()
    }
}

// MARK: AudioRecordable
extension RecordSoundViewController: AudioRecordable {
    func audioRecorder(_ audioPlayer: VodaAudioRecorder, didFinishedWithUrl url: URL?) {
        guard let recordedUrl = url else {
            return
        }
        recordedAudioUrl = recordedUrl
        print("recordedAudioURL: \(recordedUrl)")
        
        performSegue(withIdentifier: SegueIdentifier.stopRecording, sender: self)
    }
    
    func audioRecorder(_ audioPlayer: VodaAudioRecorder, didChangedStatus status: AudioRecordStatus) {
        print("recordStatus: \(status)")
        setUpRecordButtonUI(status)
    }
    
    func audioRecorder(_ audioPlayer: VodaAudioRecorder, didUpdateCurrentTime currentTime: TimeInterval) {
        recordTimeLabel.text = currentTime.stringFromTimeInterval()
        recordedDuration = currentTime
        
        audioWaveView?.add(meteringLevel: 0.5)
    }
}

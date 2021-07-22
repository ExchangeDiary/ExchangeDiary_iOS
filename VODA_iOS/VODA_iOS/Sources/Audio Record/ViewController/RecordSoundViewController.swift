//
//  RecordSoundViewController.swift
//  VODA_iOS
//
//  Created by 전소영 on 2021/07/22.
//

import UIKit
import AVFoundation

class RecordSoundViewController: UIViewController {
    @IBOutlet weak var recordSeconds: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordGuideText: UILabel!
    
    var audioRecorder: AVAudioRecorder?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    @IBAction func recordAudio(_ sender: Any) {
        recordButton.setImage(UIImage(named: "stop"), for: .normal)
        recordGuideText.isHidden = true
        
    }
}

// MARK: AVAudioRecorderDelegate
extension RecordSoundViewController: AVAudioRecorderDelegate {
    
}

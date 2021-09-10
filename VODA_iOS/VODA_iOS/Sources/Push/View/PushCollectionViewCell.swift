//
//  PushCollectionViewCell.swift
//  VODA_iOS
//
//  Created by 전소영 on 2021/09/08.
//

import UIKit

class PushCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var pushTypeImageView: UIImageView!
    @IBOutlet weak var diaryNameLabel: UILabel!
    @IBOutlet weak var pushDescriptionLabel: UILabel!
    @IBOutlet weak var pushTimeLabel: UILabel!
    @IBOutlet weak var writtenUserNameLabel: UILabel!
    
    //FIXME: 서버 연동 후 추가
    func updateUI() {
        
    }
}

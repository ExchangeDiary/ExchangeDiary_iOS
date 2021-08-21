//
//  DeadLineDiaryCollectionViewCell.swift
//  VODA_iOS
//
//  Created by 조윤영 on 2021/08/12.
//

import UIKit

class DeadLineDiaryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var diaryTitleLabel: UILabel!
    @IBOutlet weak var dDayView: UIView!
    @IBOutlet weak var dDayLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setStyle() {
        self.contentView.layer.cornerRadius = 8
        self.contentView.layer.masksToBounds = true
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = false
        self.addShadow(width: 2, height: 2, radius: 5, opacity: 0.15)
        self.layer.shadowColor = UIColor.CustomColor.vodaMainBlue.cgColor

        self.dDayView.makeCircleView()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        setStyle()
        
    }
}

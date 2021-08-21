//
//  JoinedDiaryCollectionViewCell.swift
//  VODA_iOS
//
//  Created by 조윤영 on 2021/08/12.
//

import UIKit

class JoinedDiaryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var newUpdateBadgeView: UIView!
    @IBOutlet weak var hashTagView: UIView!
    @IBOutlet weak var hashTagLabel: UILabel!
    @IBOutlet weak var participantImageView1: UIImageView!
    @IBOutlet weak var participantImageView2: UIImageView!
    @IBOutlet weak var participantImageView3: UIImageView!
    @IBOutlet weak var participantImageView4: UIImageView!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var diaryTitleLabel: UILabel!
    @IBOutlet weak var additionalParticipantsLabel: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setStyle()
    }
    
    func setStyle() {
        self.newUpdateBadgeView.makeCircleView()
        self.hashTagView.layer.borderWidth = 1
        self.hashTagView.layer.borderColor = UIColor.CustomColor.vodaMainBlue.cgColor
        
        self.coverImageView.layer.cornerRadius = 8
        self.hashTagView.makeCircleView()
        
        self.participantImageView1.makeCircleView()
        self.participantImageView2.makeCircleView()
        self.participantImageView3.makeCircleView()
        self.participantImageView4.makeCircleView()
    }
}

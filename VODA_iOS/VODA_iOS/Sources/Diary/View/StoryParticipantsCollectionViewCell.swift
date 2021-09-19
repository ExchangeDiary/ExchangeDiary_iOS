//
//  StoryParticipantsCollectionViewCell.swift
//  VODA_iOS
//
//  Created by 조윤영 on 2021/08/15.
//

import UIKit

class StoryParticipantsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.makeCircleView()
        self.profileImageView.makeCircleImageView()
    }
}

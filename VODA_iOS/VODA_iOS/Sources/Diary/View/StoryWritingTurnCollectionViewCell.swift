//
//  StoryWritingTurnCollectionViewCell.swift
//  VODA_iOS
//
//  Created by 조윤영 on 2021/08/15.
//

import UIKit

class StoryWritingTurnCollectionViewCell: UICollectionViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setStyle()

    }
    
    func setStyle() {
        self.contentView.layer.cornerRadius = 8
        self.contentView.layer.masksToBounds = true
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = false
        self.addShadow(width: 1, height: 1, radius: 6, opacity: 0.1)
    }
}

//
//  BackgroundImageCollectionViewCell.swift
//  VODA_iOS
//
//  Created by 조윤영 on 2021/08/24.
//

import UIKit

class BackgroundImageCollectionViewCell: UICollectionViewCell {
    override func layoutSubviews() {
        super.layoutSubviews()

        setStyle()
    }
    
    override var isSelected: Bool {
      didSet {
        if isSelected {
            self.layer.borderColor = UIColor.CustomColor.vodaMainBlue.cgColor
            self.layer.borderWidth = 2
        } else {
            self.layer.borderWidth = 0
        }
      }
    }

    func setStyle() {
        self.contentView.layer.cornerRadius = 16
        self.contentView.layer.masksToBounds = true
        self.layer.cornerRadius = 16
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.CustomColor.vodaMainBlue.cgColor
        self.addShadow(width: 2, height: 2, radius: 5, opacity: 0.15)
    }
}

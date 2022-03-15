//
//  InputJoinCodeCollectionViewCell.swift
//  VODA_iOS
//
//  Created by 조윤영 on 2021/08/24.
//

import UIKit

class InputJoinCodeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var joinCodeInputView: UIView!
    @IBOutlet weak var hintView: UIView!
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var completeButton: UIButton!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setStyle()
    }
    
    func setStyle() {
        self.contentView.layer.cornerRadius = 16
        self.contentView.layer.masksToBounds = true
        self.layer.cornerRadius = 16
        self.layer.masksToBounds = false
        self.addShadow(width: 3, height: 3, radius: 16, opacity: 0.16)
        
        self.joinCodeInputView.layer.cornerRadius = 8
        self.hintView.layer.cornerRadius = 8
        
        self.prevButton.makeCornerRadius(radius: 8)
        self.completeButton.makeCornerRadius(radius: 8)
    }
}

//
//  WritingPeriodCollectionViewCell.swift
//  VODA_iOS
//
//  Created by 조윤영 on 2021/09/21.
//

import UIKit

class WritingOrderModifyCell: UICollectionViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.profileImageView.makeCircleView()
    }
}

//
//  OnBoardingCollectionViewCell3.swift
//  VODA_iOS
//
//  Created by 조윤영 on 2021/10/03.
//

import UIKit

class OnBoardingCollectionViewCell3: UICollectionViewCell {
    @IBOutlet weak var startButtonView: UIView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.startButtonView.makeCornerRadius(radius: 16)
    }
}

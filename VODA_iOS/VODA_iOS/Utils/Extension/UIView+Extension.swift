//
//  UIView+Extension.swift
//  
//
//  Created by 조윤영 on 2021/08/01.
//

import UIKit

extension UIView {
    func makeCircleView() {
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = true
    }
    
    func makeCornerRadius(radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    func addShadow(width: CGFloat, height: CGFloat, radius: CGFloat, opacity: Float) {
        self.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.layer.shadowOffset = CGSize(width: width, height: height)
            
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = opacity
        self.layer.masksToBounds = false
    }
    
    func addBorder(color: UIColor, widhth: CGFloat) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = widhth
    }
    
    func makeTopSectionRound(_ radius: CGFloat = 10) {
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
    func makeSectionRoundWithoutLeft(_ radius: CGFloat = 10) {
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
    
    func makeBottomSectionRound(_ radius: CGFloat = 10) {
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
}

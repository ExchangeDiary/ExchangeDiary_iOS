//
//  CALayer+Extension.swift
//  VODA_iOS
//
//  Created by 조윤영 on 2021/09/22.
//

import UIKit
extension CALayer {
    func addBorder(_ position: [UIRectEdge], color: UIColor, width: CGFloat) {
        for edge in position {
            let border = CALayer()
            switch edge {
            case UIRectEdge.top:
            border.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: width)
            case UIRectEdge.bottom:
            border.frame = CGRect.init(x: 0, y: frame.height - width, width: frame.width, height: width)
            case UIRectEdge.left:
            border.frame = CGRect.init(x: 0, y: 0, width: width, height: frame.height)
            case UIRectEdge.right:
            border.frame = CGRect.init(x: frame.width - width, y: 0, width: width, height: frame.height)
            default: break
            }
            
            print("addCALayer")
            border.backgroundColor = color.cgColor
            self.addSublayer(border)
        }
    }
}

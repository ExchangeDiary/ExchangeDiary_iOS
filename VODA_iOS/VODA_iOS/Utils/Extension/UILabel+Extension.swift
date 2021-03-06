//
//  UILabel+Extension.swift
//  VODA_iOS
//
//  Created by 조윤영 on 2021/08/01.
//

import UIKit

extension UILabel {
    func setLineHeight(lineHeight: CGFloat) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.0
        paragraphStyle.lineHeightMultiple = lineHeight
        paragraphStyle.alignment = self.textAlignment

        let attrString = NSMutableAttributedString()
        if let attributedTextValue = self.attributedText {
            attrString.append(attributedTextValue)
        } else {
            if let textValue = self.text {
                attrString.append( NSMutableAttributedString(string: textValue))
            }
            attrString.addAttribute(NSAttributedString.Key.font, value: self.font ?? "", range: NSRange(location: 0, length: attrString.length))
       }
        
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attrString.length))
        self.attributedText = attrString
    }
}

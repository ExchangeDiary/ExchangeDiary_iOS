//
//  UIImageView+Extension.swift
//  VODA_iOS
//
//  Created by 조윤영 on 2021/08/01.
//

import UIKit
import Foundation
import Kingfisher

extension UIImageView {
    func circleImageView() {
        self.layer.cornerRadius = self.layer.frame.height / 2
        self.layer.masksToBounds = true
    }
        
    public func setImage(_ urlString: String?, defaultImgPath: String) {
        let defaultImg = UIImage(named: defaultImgPath)
            
        if let imageURL = urlString?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            if imageURL.isEmpty {
                self.image = defaultImg
            } else {
                self.kf.setImage(with: URL(string: imageURL), placeholder: defaultImg, options: [.transition(ImageTransition.fade(0.5))])
            }
        } else {
            self.image = defaultImg
        }
    }
}

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
    func makeCircleImageView() {
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = true
    }
        
    public func setImage(_ urlString: String?, defaultImagePath: String) {
        let defaultImage = UIImage(named: defaultImagePath)
            
        if let imageURL = urlString?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            if imageURL.isEmpty {
                self.image = defaultImage
            } else {
                self.kf.setImage(with: URL(string: imageURL), placeholder: defaultImage, options: [.transition(ImageTransition.fade(0.5))])
            }
        } else {
            self.image = defaultImage
        }
    }
}

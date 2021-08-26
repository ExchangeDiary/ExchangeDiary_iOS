//
//  StoryCollectionViewCell.swift
//  VODA_iOS
//
//  Created by 조윤영 on 2021/08/15.
//

import UIKit

class StoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var writerLabel: UILabel!
    @IBOutlet weak var previewDiaryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setStyle() {
        self.contentView.layer.cornerRadius = 8
        self.contentView.layer.masksToBounds = true
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = false
        self.addShadow(width: 2, height: 2, radius: 4, opacity: 0.1)

        self.profileImageView.makeCircleImageView()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setStyle()
    }
}

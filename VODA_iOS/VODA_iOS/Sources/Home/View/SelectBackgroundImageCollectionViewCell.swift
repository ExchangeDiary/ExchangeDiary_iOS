//
//  SelectBackgroundImageCollectionViewCell.swift
//  VODA_iOS
//
//  Created by 조윤영 on 2021/08/24.
//

import UIKit

class SelectBackgroundImageCollectionViewCell: UICollectionViewCell {
    
    let backgroundImageCollectionViewCellIdentifier = "backgroundImageCollectionViewCell"
    var windowHeight = UIScreen.main.bounds.size.height
    var windowWidth = UIScreen.main.bounds.size.width
    
    @IBOutlet weak var backgroundCollectionView: UICollectionView!
    
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundCollectionView.delegate = self
        self.backgroundCollectionView.dataSource = self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setStyle()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
          self.endEditing(true)
    }
    
    func setStyle() {
        self.contentView.layer.cornerRadius = 16
        self.contentView.layer.masksToBounds = true
        self.layer.cornerRadius = 16
        self.layer.masksToBounds = false
        self.addShadow(width: 3, height: 3, radius: 16, opacity: 0.16)
        
        self.prevButton.makeCornerRadius(radius: 8)
        self.nextButton.makeCornerRadius(radius: 8)
    }
}

extension SelectBackgroundImageCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let backgroundImageCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: backgroundImageCollectionViewCellIdentifier, for: indexPath) as? BackgroundImageCollectionViewCell {
            if indexPath.row == 0 {
                backgroundImageCollectionViewCell.isSelected = true
            }
            
            return backgroundImageCollectionViewCell
        }
        return UICollectionViewCell()
    }
}

extension SelectBackgroundImageCollectionViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let selectedCell = collectionView.cellForItem(at: indexPath) as? BackgroundImageCollectionViewCell {
            selectedCell.layer.borderWidth = 2
        }
    }
}

extension SelectBackgroundImageCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset = self.backgroundCollectionView.bounds.width / 20
        return UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return self.backgroundCollectionView.bounds.height / 13
        
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.backgroundCollectionView.bounds.width / 2.46
        let height = self.backgroundCollectionView.bounds.height / 2.24
            
        return CGSize(width: width, height: height)
    }
}

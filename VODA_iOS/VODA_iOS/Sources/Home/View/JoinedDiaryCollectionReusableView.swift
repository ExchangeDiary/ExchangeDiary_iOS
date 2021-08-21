//
//  JoinedDiaryCollectionReusableView.swift
//  VODA_iOS
//
//  Created by 조윤영 on 2021/08/15.
//

import UIKit

class JoinedDiaryCollectionReusableView: UICollectionReusableView, UICollectionViewDataSource {
    @IBOutlet weak var deadLineDiaryCollectionView: UICollectionView!
    @IBOutlet weak var sectionTitleView: UIView!
    
    private let deadLineDiaryCVCellIdentifier = "deadLineDiaryCollectionViewCell"
    var windowHeight = UIScreen.main.bounds.size.height
    var windowWidth = UIScreen.main.bounds.size.width
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.sectionTitleView.makeTopSectionRound(16)
        self.sectionTitleView.addShadow(width: 0, height: -4, radius: 8, opacity: 0.05)
        
        self.deadLineDiaryCollectionView.delegate = self
        self.deadLineDiaryCollectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let deadLineDiaryCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: deadLineDiaryCVCellIdentifier, for: indexPath) as? DeadLineDiaryCollectionViewCell {
                return deadLineDiaryCollectionViewCell
        }
        return UICollectionViewCell()
    }
}

extension JoinedDiaryCollectionReusableView: UICollectionViewDelegate {
    
}

extension JoinedDiaryCollectionReusableView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: windowWidth / 17.25, bottom: 5, right: windowWidth / 17.25)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return windowWidth / 17.25
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 3.3
        let height: CGFloat = collectionView.frame.height - 10
        return CGSize(width: width, height: height)
    }
}

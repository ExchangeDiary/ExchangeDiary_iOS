//
//  StoryCollectionViewFlowLayout.swift
//  VODA_iOS
//
//  Created by 조윤영 on 2021/09/10.
//

import Foundation
import UIKit

class StoryCollectionViewFlowLayout: UICollectionViewFlowLayout {
    var layoutCache: [UICollectionViewLayoutAttributes]? = nil
    
    override func prepare() {
        super.prepare()

        setInsetForSection()
        let width = DeviceInfo.screenWidth / 2.6
        var attributesList: [UICollectionViewLayoutAttributes] = []
        let statusCellHeight = DeviceInfo.screenHeight / 5.2
        let storyCellHeight = DeviceInfo.screenHeight / 3.83
        let verticalSpace = DeviceInfo.screenHeight / 33.8
        let horizontalInset = DeviceInfo.screenWidth / 11.7
        
        for index in 0...dummyStoryTitleList.count {
            let isOdd = index % 2 == 0
            let height = index == 0 ? statusCellHeight : storyCellHeight
            let attributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: index, section: 0))
            
            var frameY: CGFloat = 0
            if index > 1 {
                let upperImage = attributesList[index - 2]
                frameY = upperImage.frame.origin.y + upperImage.frame.size.height + verticalSpace
            } else { frameY = DeviceInfo.screenHeight / 2.6 }
            
            let frame = CGRect(x: isOdd ? horizontalInset : DeviceInfo.screenWidth - width - horizontalInset, y: frameY, width: width, height: height)
            attributes.frame = frame
            attributesList.append(attributes)
        }
        
        layoutCache = attributesList
    }

    private func setInsetForSection() {
        if let collectionView = self.collectionView {
            let inset =  DeviceInfo.screenHeight / 5.2 + (DeviceInfo.screenHeight / 33.8 * 2)
            collectionView.contentInset = .init(top: 0, left: 0, bottom: inset, right: 0)
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let layoutCache = layoutCache else { return super.layoutAttributesForElements(in: rect) }

        var layoutAttributes = [UICollectionViewLayoutAttributes]()

        let headerAtrributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: IndexPath(item: 0, section: 0))
        if let collectionView = self.collectionView {
            headerAtrributes.frame = CGRect(x: 0, y: 0, width: collectionView.bounds.size.width, height: DeviceInfo.screenHeight / 2.8)
        }
        
        layoutAttributes.append(headerAtrributes)

        for attributes in layoutCache {
            if attributes.frame.intersects(rect) { layoutAttributes.append(attributes) }
        }
        return layoutAttributes
    }
}

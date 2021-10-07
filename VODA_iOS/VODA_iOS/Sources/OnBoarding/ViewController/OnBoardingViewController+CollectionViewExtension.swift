//
//  OnBoardingViewController+CollectionViewExtension.swift
//  VODA_iOS
//
//  Created by 조윤영 on 2021/10/03.
//

import Foundation
import UIKit

extension OnBoardingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            if let onBoardingCell1 = collectionView.dequeueReusableCell(withReuseIdentifier: onBoardingCell1Identifier, for: indexPath) as? OnBoardingCollectionViewCell1 {
                return onBoardingCell1
            }
            
        } else if indexPath.row == 1 {
            if let onBoardingCell2 = collectionView.dequeueReusableCell(withReuseIdentifier: onBoardingCell2Identifier, for: indexPath) as? OnBoardingCollectionViewCell2 {
                    return onBoardingCell2
            }
        } else if indexPath.row == 2 {
            if let onBoardingCell3 = collectionView.dequeueReusableCell(withReuseIdentifier: onBoardingCell3Identifier, for: indexPath) as? OnBoardingCollectionViewCell3 {
                return onBoardingCell3
            }
        }
        return UICollectionViewCell()
    }
}

extension OnBoardingViewController: UICollectionViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let page = Int(targetContentOffset.pointee.x / self.onboardingCollectionView.frame.width)
        self.onBoardingPageControl.currentPage = page
      }
}

extension OnBoardingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let height = collectionView.frame.height
            
        return CGSize(width: width, height: height)
    }
}

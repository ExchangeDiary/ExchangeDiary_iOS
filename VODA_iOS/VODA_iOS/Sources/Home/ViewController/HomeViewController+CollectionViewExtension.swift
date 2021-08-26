//
//  HomeViewController+CollectionViewExtension.swift
//  VODA_iOS
//
//  Created by 조윤영 on 2021/08/21.
//

import Foundation
import UIKit
private let joinedDiaryCVCellIdentifier = "joinedDiaryCollectionViewCell"
private let joinedDiaryCVHeaderIdentifier = "joinedDiaryCollectionViewHeader"

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let joinedCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: joinedDiaryCVCellIdentifier, for: indexPath) as? JoinedDiaryCollectionViewCell {
                return joinedCollectionViewCell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: DeviceInfo.screenWidth, height: DeviceInfo.screenHeight / 2.1)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: joinedDiaryCVHeaderIdentifier, for: indexPath)
            return headerView
        default:
            assert(false, "default")
        }
        
        return UICollectionReusableView()
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dvc = UIStoryboard(name: "Diary", bundle: nil).instantiateViewController(withIdentifier: "DiaryViewController")
        dvc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(dvc, animated: true)
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: DeviceInfo.screenWidth / 17.25, bottom: collectionView.frame.height / 6.4, right: DeviceInfo.screenWidth / 17.25)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let height = collectionView.frame.height / 6.4
            
        return CGSize(width: width, height: height)
    }
}

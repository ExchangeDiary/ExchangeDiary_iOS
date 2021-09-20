//
//  NewDiaryPopUp+CollectionViewExtension.swift
//  VODA_iOS
//
//  Created by 조윤영 on 2021/08/26.
//

import UIKit

extension NewDiaryPopUp: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            if let createDiaryCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: createDiaryCollectionViewCellIdentifier, for: indexPath) as? CreateDiaryCollectionViewCell {
                createDiaryCollectionViewCell.delegate = self
                return createDiaryCollectionViewCell
            }
        } else if indexPath.row == 1 {
            if let selectBackgroundIamgeCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: selectBackgroundIamgeCollectionViewCellIdentifier, for: indexPath) as? SelectBackgroundImageCollectionViewCell {
                return selectBackgroundIamgeCollectionViewCell
            }
        } else {
            if let inputJoinCodeCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: inputJoinCodeCollectionViewCellIdentifier, for: indexPath) as? InputJoinCodeCollectionViewCell {
                    return inputJoinCodeCollectionViewCell
            }
        }
        return UICollectionViewCell()
    }
}

extension NewDiaryPopUp: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: DeviceInfo.screenHeight / 5.13, left: DeviceInfo.screenWidth / 11.3, bottom: DeviceInfo.screenHeight / 5.13, right: DeviceInfo.screenWidth / 11.3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return DeviceInfo.screenWidth / 11.3 * 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = Int(DeviceInfo.screenWidth / 1.2)
        let height = Int(DeviceInfo.screenHeight / 1.63)
    
        return CGSize(width: width, height: height)
    }
}

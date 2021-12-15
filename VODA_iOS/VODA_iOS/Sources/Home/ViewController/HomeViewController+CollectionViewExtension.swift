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

let dummyTitleList = ["주린이는 오늘도 뚠뚠", "나만 고양이 있어 방", "넥스터즈 다이어리 소모임", "일상 공유", "오늘의 맛집", "오늘의 운동"]
let dummyImageViewList = ["themeBackground1", "themeBackground2", "themeBackground3"]
let dummyhashtagList = ["#떡상 가즈아", "#동물사랑 나랑사랑", "#이직 성공 기원", "#일상 속 행복", "#매일매일 먹방찍기", "#2달 뒤 5kg감량"]

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dummyTitleList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let joinedCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: joinedDiaryCVCellIdentifier, for: indexPath) as? JoinedDiaryCollectionViewCell {
            joinedCollectionViewCell.diaryTitleLabel.text = dummyTitleList[indexPath.row]
            joinedCollectionViewCell.coverImageView.image = UIImage(named: dummyImageViewList[indexPath.row % dummyImageViewList.count])
            joinedCollectionViewCell.hashTagLabel.text = dummyhashtagList[indexPath.row]
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

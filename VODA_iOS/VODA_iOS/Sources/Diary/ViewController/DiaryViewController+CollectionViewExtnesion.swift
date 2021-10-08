//
//  DiaryViewController+CollectionViewExtnesion.swift
//  VODA_iOS
//
//  Created by 조윤영 on 2021/08/21.
//

import Foundation
import UIKit

let dummyProfileImageList = ["dummy_profile1", "dummy_profile2", "dummy_profile3", "dummy_profile4"]
let dummyStoryTitleList = ["오늘 삼성전자 주식 뭐냐", "공모주 청약 꿀팁", "주식으로 내 집 마련하기", "오늘 단타치고 치킨 시킨 썰", "오늘 삼성전자 주식 뭐냐", "공모주 청약 꿀팁", "주식으로 내 집 마련하기", "오늘 단타치고 치킨 시킨 썰", "오늘 삼성전자 주식 뭐냐", "공모주 청약 꿀팁", "주식으로 내 집 마련하기", "오늘 단타치고 치킨 시킨 썰"]

extension DiaryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "WriteStory", bundle: nil)
        guard let writeStoryViewController = storyboard.instantiateViewController(identifier: "WriteStoryViewController") as? WriteStoryViewController else {
            return
        }
        
        self.navigationController?.pushViewController(writeStoryViewController, animated: false)
    }
}

extension DiaryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10 + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            if status == "writing" {
                if let storyWritingTurnCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: writingTurnCollectionViewCellIdentifier, for: indexPath) as? StoryWritingTurnCollectionViewCell {
                    return storyWritingTurnCollectionViewCell
                }
            } else {
                if let storyReadingTurnCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: readingTurnCollectionViewCellIdentifier, for: indexPath) as? StoryReadingTurnCollectionViewCell {
                    return storyReadingTurnCollectionViewCell
                }
            }
        } else {
            if let storyCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: storyCollectionViewCellIdentifier, for: indexPath) as? StoryCollectionViewCell {
                storyCollectionViewCell.titleLabel.text = dummyStoryTitleList[indexPath.row % dummyStoryTitleList.count]
                storyCollectionViewCell.profileImageView.image = UIImage(named: dummyProfileImageList[indexPath.row % dummyProfileImageList.count])
                return storyCollectionViewCell
            }
        }
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
            return CGSize(width: DeviceInfo.screenWidth, height: DeviceInfo.screenHeight / 2.9)
    }
        
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: diaryCollectionViewHeaderIdentifier, for: indexPath)
            return headerView
        default: assert(false, "default")
        }
        return UICollectionReusableView()
    }
}

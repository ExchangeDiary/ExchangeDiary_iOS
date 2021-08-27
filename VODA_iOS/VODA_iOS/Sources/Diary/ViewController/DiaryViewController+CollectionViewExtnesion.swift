//
//  DiaryViewController+CollectionViewExtnesion.swift
//  VODA_iOS
//
//  Created by 조윤영 on 2021/08/21.
//

import Foundation
import UIKit

private let storyCollectionViewCellIdentifier = "storyCollectionviewCell"
private let writingTurnCollectionViewCellIdentifier = "storyWritingTurnCollectionViewCell"
private let readingTurnCollectionViewCellIdentifier = "storyReadingTurnCollectionViewCell"
private let diaryCollectionViewHeaderIdentifier = "diaryCollectionReusableView"
let dummyProfileImageList = ["dummy_profile1", "dummy_profile2", "dummy_profile3", "dummy_profile4"]
let dummyStoryTitleList = ["오늘 삼성전자 주식 뭐냐", "공모주 청약 꿀팁", "주식으로 내 집 마련하기", "오늘 단타치고 치킨 시킨 썰"]

extension DiaryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // FIXME: 시연을 위해 첫 번째 셀 선택 시, 무조건 일기 작성 화면으로 넘어간다.
        // NOTICE: 소영님 여기에 다이어리 작성 화면 넘어가는 코드 작성해주시면 됩니다.
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
                    storyWritingTurnCollectionViewCell.layoutIfNeeded()
                    return storyWritingTurnCollectionViewCell
                }
            } else {
                if let storyReadingTurnCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: readingTurnCollectionViewCellIdentifier, for: indexPath) as? StoryReadingTurnCollectionViewCell {
                    storyReadingTurnCollectionViewCell.layoutIfNeeded()
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
        default:
            assert(false, "default")
        }
        return UICollectionReusableView()
    }
}

extension DiaryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: DeviceInfo.screenWidth / 11.7, bottom: DeviceInfo.screenHeight / 3.83 / 2, right: DeviceInfo.screenWidth / 11.7)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return DeviceInfo.screenHeight / 33.8
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width: CGFloat = 0
        var height: CGFloat = 0

        if indexPath.row == 0 {
            width = DeviceInfo.screenWidth / 2.6
            height = DeviceInfo.screenHeight / 5.2
        } else {
            width = DeviceInfo.screenWidth / 2.6
            height = DeviceInfo.screenHeight / 3.83
        }
    
        return CGSize(width: width, height: height)
    }
}

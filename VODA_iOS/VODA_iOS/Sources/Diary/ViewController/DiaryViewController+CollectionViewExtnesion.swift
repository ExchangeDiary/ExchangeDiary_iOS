//
//  DiaryViewController+CollectionViewExtnesion.swift
//  VODA_iOS
//
//  Created by 조윤영 on 2021/08/21.
//

import Foundation
import UIKit

private let storyCollectionViewCellIdentifier = "storyCollectionviewCell"
private let noFriendCollectionViewCellIdentifier = "storyNoFriendCollectionViewCell"
private let writingTurnCollectionViewCellIdentifier = "storyWritingTurnCollectionViewCell"
private let readingTurnCollectionViewCellIdentifier = "storyReadingTurnCollectionViewCell"
private let diaryCollectionViewHeaderIdentifier = "diaryCollectionReusableView"

extension DiaryViewController: UICollectionViewDelegate {
    
}

extension DiaryViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10 + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            if participantsDummy.count == 1 {
                if let storyNoFriendCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: noFriendCollectionViewCellIdentifier, for: indexPath) as? StoryNoFriendCollectionViewCell {
                        return storyNoFriendCollectionViewCell
                }
            } else {
                if status == "writing" {
                    if let storyWritingTurnCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: writingTurnCollectionViewCellIdentifier, for: indexPath) as? StoryWritingTurnCollectionViewCell {
                            return storyWritingTurnCollectionViewCell
                    }
                } else {
                    if let storyReadingTurnCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: readingTurnCollectionViewCellIdentifier, for: indexPath) as? StoryReadingTurnCollectionViewCell {
                            return storyReadingTurnCollectionViewCell
                    }
                }
            }
        } else {
            if let storyCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: storyCollectionViewCellIdentifier, for: indexPath) as? StoryCollectionViewCell {
                    return storyCollectionViewCell
            }
        }
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.windowWidth, height: self.windowHeight / 2.9)
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
        return UIEdgeInsets(top: 0, left: windowWidth / 11.7, bottom: windowHeight / 3.83 / 2, right: windowWidth / 11.7)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return windowHeight / 33.8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width: CGFloat = 0
        var height: CGFloat = 0
        
        if indexPath.row == 0 {
            width = windowWidth / 2.6
            height = windowHeight / 5.2
        } else {
            width = windowWidth / 2.6
            height = windowHeight / 3.83
        }
            
        return CGSize(width: width, height: height)
    }
}
//
//  JoinedDiaryCollectionReusableView.swift
//  VODA_iOS
//
//  Created by 조윤영 on 2021/08/15.
//

import UIKit
protocol HomeViewControllerDelegate: AnyObject {
    func pushDiaryViewController()
}

class JoinedDiaryCollectionReusableView: UICollectionReusableView {
    @IBOutlet weak var deadLineDiaryCollectionView: UICollectionView!
    @IBOutlet weak var sectionTitleView: UIView!
    
    private let deadLineDiaryCVCellIdentifier = "deadLineDiaryCollectionViewCell"
    let dummydDayList = ["D-day", "D-1", "D-2"]
    let dummyTitleList = ["주린이는 오늘도 뚠뚠", "나만 고양이 있어 방", "넥스터즈 다이어리 소모임", "일상 공유", "오늘의 맛집", "오늘의 운동"]
    let dummyImageViewList = ["themeBackground1", "themeBackground2", "themeBackground3"]
    
    weak var delegate: HomeViewControllerDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.sectionTitleView.makeTopSectionRound(16)
        self.sectionTitleView.addShadow(width: 0, height: -4, radius: 8, opacity: 0.05)
        
        self.deadLineDiaryCollectionView.delegate = self
        self.deadLineDiaryCollectionView.dataSource = self
    }
}

extension JoinedDiaryCollectionReusableView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dummyTitleList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let deadLineDiaryCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: deadLineDiaryCVCellIdentifier, for: indexPath) as? DeadLineDiaryCollectionViewCell {
            
            deadLineDiaryCollectionViewCell.dDayLabel.text = self.dummydDayList[indexPath.row % dummydDayList.count]
            deadLineDiaryCollectionViewCell.diaryTitleLabel.text = dummyTitleList[indexPath.row]
            deadLineDiaryCollectionViewCell.coverImageView.image = UIImage(named: self.dummyImageViewList[indexPath.row % dummyImageViewList.count])
            return deadLineDiaryCollectionViewCell
        }
        return UICollectionViewCell()
    }
}

extension JoinedDiaryCollectionReusableView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // ISSUE: collectionView 내의 collectionView에서 didSelectItemAt 함수가 정상적으로 구현되지 않는다.
//        delegate?.pushDiaryViewController()
    }
}

extension JoinedDiaryCollectionReusableView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: DeviceInfo.screenWidth / 17.25, bottom: 5, right: DeviceInfo.screenWidth / 17.25)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return DeviceInfo.screenWidth / 17.25
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 3.3
        let height: CGFloat = collectionView.frame.height - 10
        return CGSize(width: width, height: height)
    }
}

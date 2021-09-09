//
//  NoticeViewController.swift
//  VODA_iOS
//
//  Created by 전소영 on 2021/08/31.
//

import UIKit

class NoticeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpNavigationUI()
    }
    
    private func setUpNavigationUI() {
        self.setBackButton(color: .black)
        self.setNavigationBarTransparency()
        
        self.navigationController?.navigationBar.titleTextAttributes = [.font: UIFont(name: "AppleSDGothicNeo-SemiBold", size: 20.0) as Any, .foregroundColor: UIColor.CustomColor.vodaGray9]
    }
}

// MARK: UICollectionViewDataSource
extension NoticeViewController: UICollectionViewDataSource {
    //FIXME: 현재 테스트만 완료, 서버 연동 필요
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoticeCollectionViewCell", for: indexPath)
        let noticeCollectionViewCell = cell as? NoticeCollectionViewCell
        
        noticeCollectionViewCell?.noticeTitleLabel.text = "보다 이용 방법"
        noticeCollectionViewCell?.noticeDateLabel.text = "210703"
        
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension NoticeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: Int(DeviceInfo.screenWidth), height: 81)
    }
}

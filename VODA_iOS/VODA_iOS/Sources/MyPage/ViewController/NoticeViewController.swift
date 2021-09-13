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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == SegueIdentifier.showNoticeDetail {
            guard let noticeDetailViewController = segue.destination as? NoticeDetailViewController else {
                return
            }
            if let indexPath = sender as? Int {
                //FIXME: 서버 연동후 변경
                noticeDetailViewController.noticeContentsText = "test notice"
            }
        }
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: SegueIdentifier.showNoticeDetail, sender: indexPath.item)
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension NoticeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: Int(DeviceInfo.screenWidth), height: 81)
    }
}

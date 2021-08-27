//
//  NewDiaryPopUp.swift
//  VODA_iOS
//
//  Created by 조윤영 on 2021/08/21.
//

import UIKit
import DropDown

class NewDiaryPopUp: UIViewController {
    let createDiaryCollectionViewCellIdentifier = "createDiaryCollectionViewCell"
    let selectBackgroundIamgeCollectionViewCellIdentifier = "selectBackgroundIamgeCollectionViewCell"
    let inputJoinCodeCollectionViewCellIdentifier = "inputJoinCodeCollectionViewCell"
    
    @IBOutlet weak var newDiaryCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.newDiaryCollectionView.isScrollEnabled = false
        
        let gesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapCollectionView(_:)))
        self.newDiaryCollectionView.addGestureRecognizer(gesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        (rootViewController as? MainViewController)?.setTabBarHidden(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        (rootViewController as? MainViewController)?.setTabBarHidden(false)
    }
    
    @objc func tapCollectionView(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    private func visibleCellIndexPath() -> IndexPath {
        return self.newDiaryCollectionView.indexPathsForVisibleItems[0]
    }
    
    @IBAction func nextButtonTouchUpInsideAction(_ sender: Any) {
        var item = visibleCellIndexPath().item
 
        item += 1
        self.newDiaryCollectionView.scrollToItem(at: IndexPath(item: item, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    @IBAction func prevButtonTouchUpInsideAction(_ sender: Any) {
        var item = visibleCellIndexPath().item
 
        item -= 1
        self.newDiaryCollectionView.scrollToItem(at: IndexPath(item: item, section: 0),
                                  at: .centeredHorizontally,
                                  animated: true)
    }
    
    @IBAction func completeButtonTouchUpInsideAction(_ sender: Any) {
        // TODO: 다이어리 추가
        // FIXME: 시연을 위해 present된 팝업화면 사라지게 임시 구현
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeButtonTouchUpInsideAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension NewDiaryPopUp: CreateDiaryCellDelegate {
    func moveToNextPage() {
        var item = visibleCellIndexPath().item

        item += 1
        self.newDiaryCollectionView.scrollToItem(at: IndexPath(item: item, section: 0), at: .centeredHorizontally, animated: true)
    }
}

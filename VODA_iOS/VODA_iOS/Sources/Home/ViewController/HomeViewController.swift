//
//  HomeViewController.swift
//  VODA_iOS
//
//  Created by 전소영 on 2021/07/30.
//

import UIKit
import DropDown

class HomeViewController: UIViewController {
    private let newDiaryPopUpIdentifier = "newDiaryPopUp"
    
    @IBOutlet weak var joinedDiaryCollectionView: UICollectionView!
    @IBOutlet weak var createNewDiaryButton: UIBarButtonItem!
    var participants = [UIImageView]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.navigationController?.setNavigationBarTransparency()
        self.createNewDiaryButton.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    func pushDiaryViewController() {
        let dvc = UIStoryboard(name: "Diary", bundle: nil).instantiateViewController(withIdentifier: "DiaryViewController")
        dvc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(dvc, animated: true)
    }
    
    @IBAction func createNewDiaryTouchUpInsideAction(_ sender: Any) {
        guard let newDiaryPopUp = self.storyboard?.instantiateViewController(identifier: "newDiaryPopUp") else { return }
        newDiaryPopUp.modalPresentationStyle = .overCurrentContext
        self.present(newDiaryPopUp, animated: true, completion: nil)
    }
}

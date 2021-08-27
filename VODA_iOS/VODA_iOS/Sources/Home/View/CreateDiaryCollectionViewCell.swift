//
//  CreateDiaryCollectionViewCell.swift
//  VODA_iOS
//
//  Created by 조윤영 on 2021/08/21.
//

import UIKit
import DropDown

protocol CreateDiaryCellDelegate: AnyObject {
    func moveToNextPage()
}

class CreateDiaryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var diaryThemeView: UIView!
    @IBOutlet weak var diaryNameView: UIView!
    @IBOutlet weak var cycleSelectionView: UIView!
    @IBOutlet weak var cycleSelectionArrowImageView: UIImageView!
    @IBOutlet weak var cycleSelectionLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var diaryThemeTextfield: UITextField!
    @IBOutlet weak var diaryNameTextField: UITextField!
    
    private let dropDown = DropDown()
    weak var delegate: CreateDiaryCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setStyle()
        setDropDownStyle()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
          self.endEditing(true)
    }
    
    @IBAction func nextButtonTouchUpInsideAction(_ sender: Any) {
        if self.diaryThemeTextfield.text?.isEmpty == true || self.diaryNameTextField.text?.isEmpty == true {
            showWarning()
        } else {
            self.delegate?.moveToNextPage()
        }
    }
    
    func showWarning() {
        if self.diaryThemeTextfield.text?.isEmpty == true { self.diaryThemeView.layer.borderColor = UIColor.red.cgColor
        }
        
        if self.diaryNameTextField.text?.isEmpty == true {
            self.diaryNameView.layer.borderColor = UIColor.red.cgColor
        }
    }
    
    @IBAction func cycleSelectionButtonTouchUpInsideAction(_ sender: Any) {
        dropDown.show()
        changeCycleSelectionViewStyle()
    }
    
    func changeCycleSelectionViewStyle() {
        self.cycleSelectionView.layer.borderColor = UIColor.CustomColor.vodaMainBlue.cgColor
        self.cycleSelectionArrowImageView.image = UIImage(named: "arrow_down_activate")
    }
    
    func initCycleSelectionViewStyle() {
        self.cycleSelectionView.layer.borderColor = UIColor.CustomColor.vodaGray5.cgColor
        self.cycleSelectionArrowImageView.image = UIImage(named: "arrow_down_inactivate")
    }
    
    func setStyle() {
        self.contentView.layer.cornerRadius = 16
        self.contentView.layer.masksToBounds = true
        self.layer.cornerRadius = 16
        self.layer.masksToBounds = false
        self.addShadow(width: 3, height: 3, radius: 16, opacity: 0.16)
        
        self.diaryThemeView.layer.cornerRadius = 8
        self.diaryThemeView.layer.borderWidth = 1
        self.diaryThemeView.layer.borderColor = UIColor.CustomColor.vodaGray5.cgColor
        
        self.diaryNameView.layer.cornerRadius = 8
        self.diaryNameView.layer.borderWidth = 1
        self.diaryNameView.layer.borderColor = UIColor.CustomColor.vodaGray5.cgColor
        
        self.cycleSelectionView.layer.cornerRadius = 8
        self.cycleSelectionView.layer.borderWidth = 1
        self.initCycleSelectionViewStyle()
        
        self.nextButton.layer.cornerRadius = 8
    }
    
    func setDropDownStyle() {
        dropDown.cellHeight = self.contentView.bounds.height / 16
        dropDown.direction = .bottom
        dropDown.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        dropDown.textColor = #colorLiteral(red: 0.737254902, green: 0.737254902, blue: 0.737254902, alpha: 1)
        dropDown.textFont = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)!
        dropDown.layer.borderColor = UIColor.CustomColor.vodaGray6.cgColor
        dropDown.layer.borderWidth = 1
        dropDown.makeBottomSectionRound(8)
        dropDown.shadowRadius = 0
        dropDown.animationEntranceOptions = .transitionCurlDown
    
        dropDown.dataSource = ["1일", "2일", "3일", "4일", "5일", "6일", "7일"]
        dropDown.anchorView = self.cycleSelectionView
        dropDown.width = self.cycleSelectionView.bounds.width
        if let dropDownHeight = dropDown.anchorView?.plainView.bounds.height {
            dropDown.bottomOffset = CGPoint(x: 0, y: dropDownHeight)
        }
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print(index)
            self.cycleSelectionLabel.text = item
            self.cycleSelectionLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.initCycleSelectionViewStyle()
        }
    }
}

extension CreateDiaryCollectionViewCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case self.diaryThemeTextfield:
            self.diaryThemeView.layer.borderColor = UIColor.CustomColor.vodaGray5.cgColor
        case self.diaryNameTextField:
            self.diaryNameView.layer.borderColor = UIColor.CustomColor.vodaGray5.cgColor
        default:
            break
        }
    }
}

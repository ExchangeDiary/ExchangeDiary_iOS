//
//  WritePeroidPopUpViewController.swift
//  VODA_iOS
//
//  Created by 전소영 on 2021/08/15.
//

import UIKit

class WritePeroidPopUpViewController: UIViewController {
    @IBOutlet weak var writePeriodPickerView: UIPickerView!
    private let periodList = ["1일", "2일", "3일", "4일", "5일", "6일", "7일"]
    private var selectedRow = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        writePeriodPickerView.delegate = self
        writePeriodPickerView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        writePeriodPickerView.subviews[1].isHidden = true
    }
    
    @IBAction func selectWritePeriod(_ sender: Any) {
        //TODO: 선택된 작성 주기 전달하기
//        periodList[selectedRow]
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
}

// MARK: UIPickerViewDelegate
extension WritePeroidPopUpViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRow = row
        print("selectedRow: \(selectedRow)")
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.textAlignment = .center
        
        label.layer.borderColor = UIColor.CustomColor.vodaGray3.cgColor
        label.layer.borderWidth = 1
        
        //TODO: 추후 font명 따라 변경해야 함
        label.font = UIFont(name: "SFProDisplay-Semibold", size: 20)
        label.text = periodList[row]
        
        return label
    }
}

// MARK: UIPickerViewDataSource
extension WritePeroidPopUpViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return periodList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return periodList[row]
    }
}

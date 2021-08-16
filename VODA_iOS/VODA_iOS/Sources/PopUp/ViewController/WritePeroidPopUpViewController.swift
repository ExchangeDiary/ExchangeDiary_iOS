//
//  WritePeroidPopUpViewController.swift
//  VODA_iOS
//
//  Created by 전소영 on 2021/08/15.
//

import UIKit

class WritePeroidPopUpViewController: UIViewController {
    @IBOutlet weak var writePeriodPickerView: UIPickerView!
    let periodList = ["1일", "2일", "3일", "4일", "5일", "6일", "7일"]
    var selectedRow = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        writePeriodPickerView.delegate = self
        writePeriodPickerView.dataSource = self
    }
    
    @IBAction func selectWritePeriod(_ sender: Any) {
        //TODO: 선택된 작성 주기 전달하기
//        periodList[selectedRow]
    }
}

// MARK: UIPickerViewDelegate
extension WritePeroidPopUpViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRow = row
        print("selectedRow: \(selectedRow)")
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

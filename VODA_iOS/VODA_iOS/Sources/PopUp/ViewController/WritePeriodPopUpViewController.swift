//
//  WritePeriodPopUpViewController.swift
//  VODA_iOS
//
//  Created by 전소영 on 2021/08/15.
//

import UIKit

protocol WritePeriodPopUpDelegate: AnyObject {
  func changeWritePeriod(_ period: String)
}

class WritePeriodPopUpViewController: UIViewController {
    @IBOutlet weak var writePeriodPickerView: UIPickerView!
    private let periodList = ["1일", "2일", "3일", "4일", "5일", "6일", "7일"]
    private var selectedRow = 0
    weak var writePeriodDelegate: WritePeriodPopUpDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        writePeriodPickerView.delegate = self
        writePeriodPickerView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        writePeriodPickerView.subviews[1].isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    @IBAction func selectWritePeriod(_ sender: Any) {
        writePeriodDelegate?.changeWritePeriod(periodList[selectedRow])
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func tapBackgroundCancel(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
}

// MARK: UIPickerViewDelegate
extension WritePeriodPopUpViewController: UIPickerViewDelegate {
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
        
        label.layer.addBorder([.bottom], color: UIColor.CustomColor.vodaGray3, width: 1)
        label.layoutIfNeeded()
        label.setNeedsLayout()

        let lineView = UIView(frame: CGRect(x: 0, y: label.frame.height - 3, width: label.frame.width, height: 3.0))
        lineView.backgroundColor = UIColor.black
        label.addSubview(lineView)
        
        // TODO: 추후 font명 따라 변경해야 함
        label.font = UIFont(name: "SFProDisplay-Semibold", size: 20)
        label.text = periodList[row]
        
        return label
    }
}

// MARK: UIPickerViewDataSource
extension WritePeriodPopUpViewController: UIPickerViewDataSource {
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

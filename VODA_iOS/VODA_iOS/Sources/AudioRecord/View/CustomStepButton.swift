//
//  CustomStepButton.swift
//  VODA_iOS
//
//  Created by 전소영 on 2021/08/12.
//

import UIKit

protocol ButtonClickEventDetectable: AnyObject {
    func detectClickEvent()
}

class CustomStepButton: UIButton {
    @IBOutlet weak var title: UIButton!
    @IBOutlet var backgroundView: UIView!
    
    weak var delegate: ButtonClickEventDetectable?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        let bundle = Bundle.init(for: self.classForCoder)
        guard let view = bundle.loadNibNamed("CustomStepButton", owner: self, options: nil)?.first as? UIView else {
            return
        }
        
        self.addSubview(view)
    }
    @IBAction func clickButton(_ sender: UIButton) {
        delegate?.detectClickEvent()
    }
}

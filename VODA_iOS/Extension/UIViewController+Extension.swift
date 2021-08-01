//
//  UIViewController+Extension.swift
//  VODA_iOS
//
//  Created by 조윤영 on 2021/08/01.
//

import UIKit

extension UIViewController {
    func gono(_ value: Any?) -> Any {
        if let nValue = value {
            return nValue
        } else {
            return []
        }
    }
    
    func gsno(_ value: String?) -> String {
        if let nValue = value {
            return nValue
        } else {
            return ""
        }
    }
    
    func gino(_ value: Int?) -> Int {
        if let nValue = value {
            return nValue
        } else {
            return -1
        }
    }
    
    func gfno(_ value: Float?) -> Float {
        if let nValue = value {
            return nValue
        } else {
            return -1.0
        }
    }
        
    func gdno(_ value: Double?) -> Double {
        if let nValue = value {
            return nValue
        } else {
            return -1.0
        }
    }
    
    func gbno(_ value: Bool?) -> Bool {
        if let nValue = value {
            return nValue
        } else {
            return false
        }
    }

    func eraseNavigationUnderbar() {
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    func networkErrorAlert() {
        let alert = UIAlertController(title: "네트워크 오류", message: "잠시 후에 다시 시도해주세요!", preferredStyle: .alert)
        alert.view.tintColor = UIColor.red
        let okAction = UIAlertAction(title: "확인", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
        
    func setBackBtnColor(color: UIColor) {
        navigationItem.leftBarButtonItem?.tintColor = color
        navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
    }

    func setBackBtn(color: UIColor) {
        let backBTN = UIBarButtonItem(image: UIImage(named: "icBack"), // 백버튼 이미지 파일 이름에 맞게 변경해주세요.
                style: .plain,
                target: self,
                action: #selector(self.pop))
        navigationItem.leftBarButtonItem = backBTN
        navigationItem.leftBarButtonItem?.tintColor = color
        navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
    }
    
    func setNavigationBarTransparency() {
        let navigationBar: UINavigationBar! = self.navigationController?.navigationBar
        navigationBar.backgroundColor = UIColor.white
            
        navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationBar.shadowImage = UIImage()
    }

    func simpleAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
        
    func simpleAlertwithHandler(title: String, message: String, okHandler: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: okHandler)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
        
    @objc func pop() {
        self.navigationController?.popViewController(animated: true)
    }
}

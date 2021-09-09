//
//  UIViewController+Extension.swift
//  VODA_iOS
//
//  Created by 조윤영 on 2021/08/01.
//

import UIKit

extension UIViewController {
    var rootViewController: UIViewController? {
        return UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.rootViewController
    }
}

extension UIViewController {
    func eraseNavigationUnderbar() {
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    func showNetworkErrorAlert() {
        let alert = UIAlertController(title: "네트워크 오류", message: "잠시 후에 다시 시도해주세요!", preferredStyle: .alert)
        alert.view.tintColor = UIColor.red
        let okAction = UIAlertAction(title: "확인", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
        
    func setBackButtonColor(_ color: UIColor) {
        navigationItem.leftBarButtonItem?.tintColor = color
        navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
    }

    func setBackButton(color: UIColor) {
        let backButton = UIBarButtonItem(image: UIImage(named: "icBack"), // 백버튼 이미지 파일 이름에 맞게 변경해주세요.
                style: .plain,
                target: self,
                action: #selector(self.pop))
        navigationItem.leftBarButtonItem = backButton
        navigationItem.leftBarButtonItem?.tintColor = color
        navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
    }
    
    func setNavigationBarTransparency() {
        let navigationBar = self.navigationController?.navigationBar
        navigationBar?.backgroundColor = UIColor.white
            
        navigationBar?.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationBar?.shadowImage = UIImage()
    }
    
    func setNavigationBarColor(color: UIColor) {
        let navigationBar = self.navigationController?.navigationBar
        navigationBar?.backgroundColor = color
        navigationBar?.setBackgroundImage(UIImage(), for: .default)
        navigationBar?.shadowImage = UIImage()
    }

    func showSimpleAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
        
    func showSimpleAlertwithHandler(title: String, message: String, okHandler: ((UIAlertAction) -> Void)?) {
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
    
    func showButtonPopUp(with type: ButtonPopUpType, completionHandler: (() -> Void)? = nil) {
        let storyboard = UIStoryboard(name: "PopUp", bundle: nil)
        guard let buttonPopUpViewController = storyboard.instantiateViewController(withIdentifier: "ButtonPopUpViewController") as? ButtonPopUpViewController else {
            return
        }
        buttonPopUpViewController.popUpType = type
        buttonPopUpViewController.completionHandler = completionHandler
        buttonPopUpViewController.modalPresentationStyle = .overCurrentContext
        self.present(buttonPopUpViewController, animated: false, completion: nil)
    }
    
    func showAddPhotoPopUp(completionHandler: ((UIImage) -> Void)? = nil) {
        let storyboard = UIStoryboard(name: "PopUp", bundle: nil)
        guard let photoPopUpViewController = storyboard.instantiateViewController(withIdentifier: "PhotoPopUpViewController") as? PhotoPopUpViewController else {
            return
        }
        photoPopUpViewController.modalPresentationStyle = .overCurrentContext
        photoPopUpViewController.completionHandler = completionHandler
        self.present(photoPopUpViewController, animated: false, completion: nil)
    }
    
    func showWritePeriodPopUp() {
        let storyboard = UIStoryboard(name: "PopUp", bundle: nil)
        guard let writePeriodPopUpViewController = storyboard.instantiateViewController(withIdentifier: "WritePeriodPopUpViewController") as? WritePeriodPopUpViewController else {
            return
        }
        writePeriodPopUpViewController.modalPresentationStyle = .overCurrentContext
        self.present(writePeriodPopUpViewController, animated: false, completion: nil)
    }
    
    func showLoadingView() {
        let storyboard = UIStoryboard(name: "Loading", bundle: nil)
        guard let loadingViewController = storyboard.instantiateViewController(identifier: "LoadingViewController") as? LoadingViewController else {
            return
        }
        loadingViewController.modalPresentationStyle = .fullScreen
        
        self.navigationController?.present(loadingViewController, animated: false, completion: nil)
    }
}

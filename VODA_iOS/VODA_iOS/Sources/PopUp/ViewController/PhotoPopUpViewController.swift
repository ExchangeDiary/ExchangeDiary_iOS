//
//  PhotoPopUpViewController.swift
//  VODA_iOS
//
//  Created by 전소영 on 2021/08/15.
//

import UIKit

class PhotoPopUpViewController: UIViewController {
    @IBOutlet weak var backgroundView: UIImageView!
    @IBOutlet weak var cameraStackView: UIStackView!
    @IBOutlet weak var photoAlbumStackView: UIStackView!
    private let imagePickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupImagePicker()
        addTapGesture()
    }
    
    private func setupImagePicker() {
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
    }
    
    private func addTapGesture() {
        cameraStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openCamera)))
        photoAlbumStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openPhotoAlbum)))
        backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cancel)))
    }
    
    @objc private func openCamera() {
        imagePickerController.sourceType = .camera
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc private func openPhotoAlbum() {
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc private func cancel() {
        self.dismiss(animated: false, completion: nil)
    }
}

// MARK: UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension PhotoPopUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        //TODO: 선택된 사진 넘기기
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        
        self.dismiss(animated: true, completion: nil)
    }
}

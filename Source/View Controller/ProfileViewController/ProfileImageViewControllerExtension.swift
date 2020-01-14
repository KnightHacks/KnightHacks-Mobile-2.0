//
//  ProfileImageViewControllerExtension.swift
//  KnightHacks
//
//  Created by Jamal Yauhari on 1/5/20.
//  Copyright © 2020 KnightHacks. All rights reserved.
//

import UIKit

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    internal func presentCameraPickerViewController() {
        let imagePickerViewController = UIImagePickerController()
        imagePickerViewController.delegate = self
        imagePickerViewController.allowsEditing = true
        imagePickerViewController.sourceType = .photoLibrary
        self.present(imagePickerViewController, animated: true, completion: nil)
    }
    
    // MARK: - Camera Picker Delegate functions
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imageSelected = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profilePictureButton.imageView?.image = imageSelected
            profilePictureButton.imageView?.contentMode = .scaleAspectFit
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

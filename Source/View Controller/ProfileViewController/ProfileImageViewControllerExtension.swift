//
//  ProfileImageViewControllerExtension.swift
//  KnightHacks
//
//  Created by Jamal Yauhari on 1/5/20.
//  Copyright © 2020 KnightHacks. All rights reserved.
//

import UIKit

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func showUIImagePickerControllerActionSheet() {
        let imageFromLibraryAction = UIAlertAction(title: "Choose from Library", style: .default) { (_) in
            self.presentCameraPickerViewController(source: .photoLibrary)
        }
        
        let takePictureAction = UIAlertAction(title: "Take Photo", style: .default) { (_) in
            self.presentCameraPickerViewController(source: .camera)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let actionSheet = UIAlertController(title: "Change Profile Photo", message: "", preferredStyle: .actionSheet)
        actionSheet.addAction(imageFromLibraryAction)
        actionSheet.addAction(takePictureAction)
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true)
    }
    
    internal func presentCameraPickerViewController(source: UIImagePickerController.SourceType) {
        let imagePickerViewController = UIImagePickerController()
        imagePickerViewController.delegate = self
        imagePickerViewController.allowsEditing = true
        imagePickerViewController.sourceType = source
        self.present(imagePickerViewController, animated: true, completion: nil)
    }
    
    // MARK: - Camera Picker Delegate functions
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let imageSelected = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            profilePictureButton.tintColor = .clear
            profilePictureButton.setImage(imageSelected, for: .normal)
            profilePictureButton.imageView?.contentMode = .scaleAspectFill
            _ = UserDefaultsHolder.set(profileImage: imageSelected)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

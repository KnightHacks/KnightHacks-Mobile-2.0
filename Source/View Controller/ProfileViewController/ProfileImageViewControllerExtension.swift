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
    
    // Mark: Camera Picker Delegate functions
}

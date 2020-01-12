//
//  ProfileViewControllerExtension.swift
//  KnightHacks
//
//  Created by Lloyd Dapaah on 1/3/20.
//  Copyright © 2020 KnightHacks. All rights reserved.
//

import UIKit

extension ProfileViewController {
    
    internal func setupProfilePictureButton() {
        self.profilePictureButton.layer.cornerRadius = self.profilePictureButton.frame.height / 2
        self.profilePictureButton.clipsToBounds = true
        
        self.cameraIconImageView.translatesAutoresizingMaskIntoConstraints = false
        self.cameraIconImageView.trailingAnchor.constraint(equalTo: self.profilePictureButton.trailingAnchor, constant: 0).isActive = true
        self.cameraIconImageView.bottomAnchor.constraint(equalTo: self.profilePictureButton.bottomAnchor, constant: 0).isActive = true
        self.cameraIconImageView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        self.cameraIconImageView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        self.cameraIconImageView.clipsToBounds = true
        self.cameraIconImageView.contentMode = .scaleAspectFit
        self.cameraIconImageView.layer.cornerRadius = 25 / 2
        self.cameraIconImageView.layer.borderWidth = 0.5
        self.cameraIconImageView.layer.borderColor = PROFILE_BACKGROUND_COLOR.cgColor
    }
    
    private func controlActiveSessionNavigation() {
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.navigationBar.barTintColor = PROFILE_BACKGROUND_COLOR
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.backgroundColor = .clear
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = BACKGROUND_COLOR
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.profileBackgroundImageView.backgroundColor = PROFILE_BACKGROUND_COLOR
        self.settingsBackgroundTopAnchor.constant = self.activeSessionTopAnchor
        self.view.layoutIfNeeded()
    }
    
    internal func setupActiveSessionNavigation(withAnimation: Bool = false) {
        
        guard withAnimation else {
            controlActiveSessionNavigation()
            
            return
        }
        
        UIView.animate(withDuration: 0.37, delay: 0, options: .curveEaseOut, animations: {
            self.controlActiveSessionNavigation()
        })
    }
    
    private func controlNonActiveSessionNavigation() {
        self.add(navigationController: self.navigationController, and: self.navigationItem, with: BACKGROUND_COLOR)
        
        self.navigationItem.title = "Profile"
        self.navigationController?.navigationBar.tintColor = .white
        self.settingsBackgroundTopAnchor.constant = self.nonActiveSessionTopAnchor
        self.view.layoutIfNeeded()
        
        if #available(iOS 11, *) {
            self.navigationItem.largeTitleDisplayMode = .always
            self.navigationController?.navigationBar.largeTitleTextAttributes = [
                NSAttributedString.Key.foregroundColor: UIColor.white,
                NSAttributedString.Key.font: CELL_HEADER_FONT
            ]
        }
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    internal func setupNonActiveSessionNavigation(withAnimation: Bool = false) {
        
        guard withAnimation else {
            controlNonActiveSessionNavigation()
            return
        }
        
        UIView.animate(withDuration: 0.37, delay: 0, options: .curveEaseOut, animations: {
            self.controlNonActiveSessionNavigation()
        }) { _ in
            UIView.animate(withDuration: 0.2, animations: {
                self.profileBackgroundImageView.backgroundColor = BACKGROUND_COLOR
            })
        }
    }
}

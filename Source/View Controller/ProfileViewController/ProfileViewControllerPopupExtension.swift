//
//  ProfileViewControllerPopupExtension.swift
//  KnightHacks
//
//  Created by Lloyd Dapaah on 1/7/20.
//  Copyright © 2020 KnightHacks. All rights reserved.
//

import UIKit

extension ProfileViewController {
    
    internal func setupQRDisplayView() {
        addSpecifiedShadow(self.QRDisplayCenterView)
        self.QRDisplayCenterView.layer.cornerRadius = 28
        self.QRDisplayBackgroundView.isHidden = true
        self.QRDisplayBackgroundView.alpha = 0
        
        let heightOffset = self.navigationController?.navigationBar.frame.height ?? -1
        let frame = CGRect(x: 0, y: -heightOffset - 1, width: self.view.frame.width, height: self.view.frame.height)
        self.QRDisplayBackgroundView.frame = frame
        self.view.addSubview(self.QRDisplayBackgroundView)
    }
    
    internal func setupConfirmLogoutPanel() {
        addSpecifiedShadow(self.confirmLogoutButton)
        addSpecifiedShadow(self.confirmLogoutBackgroundView)
        self.confirmLogoutBackgroundView.layer.cornerRadius = 28
        self.confirmLogoutPanelBottomAnchor.constant = logoutHiddenBottomAnchor
    }
    
    internal func showQRDisplayBackgroundView() {
        self.QRDisplayBackgroundView.alpha = 0
        self.QRDisplayBackgroundView.isHidden = false
        self.QRImageView.image = viewModel.qrCodeImage
        self.QRDisplayNameLabel.text = viewModel.hackerInfo?.name
        UIView.animate(withDuration: 0.3) {
            self.QRDisplayBackgroundView.alpha = 1
        }
    }
    
    internal func hideQRDisplayBackgroundView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.QRDisplayBackgroundView.alpha = 0
        }) { _ in
            self.QRDisplayBackgroundView.isHidden = true
        }
    }
    
    internal func showConfirmLogoutPanel() {
        UIView.animate(withDuration: 0.3, animations: {
            self.confirmLogoutPanelBottomAnchor.constant = self.logoutRisenBottomAnchor
            self.view.layoutIfNeeded()
        }) { (_) in
            self.addGestureRecognizer()
        }
    }
    
    internal func hideConfirmLogoutPanel() {
        UIView.animate(withDuration: 0.3) {
            self.confirmLogoutPanelBottomAnchor.constant = self.logoutHiddenBottomAnchor
            self.view.layoutIfNeeded()
        }
        self.coverView?.removeFromSuperview()
        self.coverView = nil
    }
    
    internal func addGestureRecognizer() {
        let bottomOffset = self.confirmLogoutBackgroundView.frame.height
        let height = self.view.frame.height - bottomOffset + 10
        let coverView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: height))
        coverView.backgroundColor = .clear
        coverView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(respondToScreenTapped)))
        self.view.addSubview(coverView)
        self.coverView = coverView
    }
    
    @objc private func respondToScreenTapped() {
        hideConfirmLogoutPanel()
    }
}

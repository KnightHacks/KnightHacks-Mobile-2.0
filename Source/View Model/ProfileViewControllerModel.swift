//
//  ProfileViewControllerModel.swift
//  KnightHacks
//
//  Created by Patrick Stoebenau on 10/21/19.
//  Copyright © 2019 KnightHacks. All rights reserved.
//

import UIKit

internal class ProfileViewControllerModel {
    
    private let nonActiveSessionMenuItems = [
        SettingsMenuModel(function: .automaticLogin, title: "Scan QR Code to Login", imageName: "profile-menu-qr"),
        SettingsMenuModel(function: .manualLogin, title: "Enter ID to Login", imageName: "profile-menu-code"),
        SettingsMenuModel(function: .navigateNextViewController, title: "My Notification Settings", imageName: "profile-menu-notifications")
    ]
    
    private let activeSessionMenuItems = [
        SettingsMenuModel(function: .presentQRCode, title: "Show my QR Code", imageName: "profile-menu-qr"),
        SettingsMenuModel(function: .navigateNextViewController, title: "My Groups", imageName: "profile-menu-groups"),
        SettingsMenuModel(function: .navigateNextViewController, title: "My Notification Settings", imageName: "profile-menu-notifications"),
        SettingsMenuModel(function: .logout, title: "Logout", imageName: "profile-menu-logout")
    ]
    
    internal private(set) var tableContent: [SettingsMenuModel] = []
    internal private(set) var hackerInfo: HackerModel?
    internal private(set) var qrCodeImage: UIImage?
    
    internal var isActiveSession: Bool = false {
        didSet {
            if isActiveSession {
                tableContent = activeSessionMenuItems
            } else {
                tableContent = nonActiveSessionMenuItems
            }
        }
    }
    
    init() {
        reloadLocalSessionIfNeeded()
    }
    
    internal func loginHacker(publicUUID: String, completion: @escaping (Bool) -> Void) {
        HackerRequestSingletonFunction.loginHacker(publicUUID: publicUUID) { (authCode) in
            guard let authCode = authCode else {
                self.isActiveSession = false
                completion(false)
                return
            }
            
            let uuid = HackerUUID(publicUUID: publicUUID, authCode: authCode)
            UserDefaultsHolder.setUser(uuid)
            self.hackerInfo = HackerModel(uuid: uuid)
            self.qrCodeImage = self.generateQRCode(from: publicUUID)
            self.isActiveSession = true
            completion(true)
        }
    }
    
    internal func reloadLocalSessionIfNeeded() {
        guard self.hackerInfo == nil, let uuid = UserDefaultsHolder.getHackerUUID() else {
            self.isActiveSession = false
            return
        }
        
        self.hackerInfo = HackerModel(uuid: uuid)
        self.qrCodeImage = self.generateQRCode(from: uuid.publicUUID)
        self.isActiveSession = true
    }
    
    internal func reloadQRCodeImageIfNeeded() {
        guard self.qrCodeImage == nil, let uuid = self.hackerInfo?.uuid.publicUUID else {
            return
        }
        self.qrCodeImage = self.generateQRCode(from: uuid)
    }
    
    internal func logoutHacker(completion: @escaping (Bool) -> Void) {
        guard let hackerUUID = self.hackerInfo?.uuid else {
            self.isActiveSession = false
            self.clearLocalHackerData()
            completion(true)
            return
        }
        
        HackerRequestSingletonFunction.logoutHacker(publicUUID: hackerUUID.publicUUID, authCode: hackerUUID.authCode) { (didLogout) in
            self.isActiveSession = !didLogout
            self.clearLocalHackerData()
            completion(didLogout)
            return
        }
    }
    
    private func clearLocalHackerData() {
        self.qrCodeImage = nil
        self.hackerInfo = nil
        UserDefaultsHolder.clearHackerData()
    }
    
    internal func getHackerInfo(completion: @escaping (Bool) -> Void) {
        completion(true)
    }
    
    // Credit: https://www.hackingwithswift.com/example-code/media/how-to-create-a-qr-code
    public func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        
        return nil
    }
}

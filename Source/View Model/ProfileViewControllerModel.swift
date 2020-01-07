//
//  ProfileViewControllerModel.swift
//  KnightHacks
//
//  Created by Patrick Stoebenau on 10/21/19.
//  Copyright © 2019 KnightHacks. All rights reserved.
//

import Foundation

internal class ProfileViewControllerModel {
    
    private let nonActiveSessionMenuItems = [
        SettingsMenuModel(function: .automaticLogin, title: "Scan QR Code to Login", imageName: "kh-blue"),
        SettingsMenuModel(function: .manualLogin, title: "Enter ID to Login", imageName: "kh-blue"),
        SettingsMenuModel(function: .navigateNextViewController, title: "My Notification Settings", imageName: "kh-blue")
    ]
    
    private let activeSessionMenuItems = [
        SettingsMenuModel(function: .navigateNextViewController, title: "Show my QR Code", imageName: "kh-blue"),
        SettingsMenuModel(function: .navigateNextViewController, title: "My Groups", imageName: "kh-blue"),
        SettingsMenuModel(function: .navigateNextViewController, title: "My Notifications", imageName: "kh-blue"),
        SettingsMenuModel(function: .logout, title: "Logout", imageName: "kh-blue")
    ]
    
    internal private(set) var tableContent: [SettingsMenuModel] = []
    internal var isActiveSession: Bool = false {
        didSet {
            if isActiveSession {
                tableContent = activeSessionMenuItems
            } else {
                tableContent = nonActiveSessionMenuItems
            }
        }
    }
    
    init(isActiveSession: Bool) {
        self.isActiveSession = isActiveSession
    }
}

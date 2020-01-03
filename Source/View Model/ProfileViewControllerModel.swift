//
//  ProfileViewControllerModel.swift
//  KnightHacks
//
//  Created by Patrick Stoebenau on 10/21/19.
//  Copyright © 2019 KnightHacks. All rights reserved.
//

import Foundation

internal class ProfileViewControllerModel {
    let nonActiveSessionMenuItems = [
        SettingsMenuModel(function: .scanQR, title: "Scan QR Code to Login", imageName: "kh-blue"),
        SettingsMenuModel(function: .navigateNextViewController, title: "My Notification Settings", imageName: "kh-blue")
    ]
}

//
//  SettingsMenuModel.swift
//  KnightHacks
//
//  Created by Lloyd Dapaah on 1/3/20.
//  Copyright © 2020 KnightHacks. All rights reserved.
//

import Foundation

enum SettingsMenuModelFunction {
    case automaticLogin
    case manualLogin
    case presentQRCode
    case navigateNextViewController
    case logout
}

internal struct SettingsMenuModel {
    var function: SettingsMenuModelFunction
    var title: String
    var imageName: String
}

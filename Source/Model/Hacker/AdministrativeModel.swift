//
//  AdministrativeModel.swift
//  KnightHacks
//
//  Created by Lloyd Dapaah on 1/1/20.
//  Copyright © 2020 KnightHacks. All rights reserved.
//

import Foundation

struct AdministrativeModel: Codable {
    var authCode: String
    var foodGroup: String
    var pointsGroup: String
    var privateUuid: String
    var publicUuid: String
}

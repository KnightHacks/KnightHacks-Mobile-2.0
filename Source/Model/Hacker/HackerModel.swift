//
//  HackerModel.swift
//  KnightHacks
//
//  Created by Lloyd Dapaah on 1/7/20.
//  Copyright © 2020 KnightHacks. All rights reserved.
//

import Foundation

struct HackerModel {
    var uuid: HackerUUID
    
    var privateUUID: String = ""
    var name: String = ""
    var points: Int = 0
    
    var pointsGroup: String = "Unassigned"
    var foodGroup: String = "Unassigned"
    
    init(uuid: HackerUUID) {
        self.uuid = uuid
    }
}

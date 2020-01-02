//
//  UserDefaultsHolder.swift
//  KnightHacks
//
//  Created by Lloyd Dapaah on 12/19/19.
//  Copyright © 2019 KnightHacks. All rights reserved.
//

import Foundation

internal struct HackerUUID {
    var publicUUID: String
    var privateUUID: String
}

struct UserDefaultsHolder {
    
    private static let publicUUIDKey: String = "publicUUID"
    private static let privateUUIDKey: String = "privateUUID"
    
    enum RequestKey: String {
        case isSubscribedToGeneralNotifications
        case isSubscribedToFoodNotifications
        case isSubscribedToEmergencyNotifications
    }
    
    static func getUserDefaultValueFor(_ key: RequestKey) -> Bool {
        return UserDefaults.standard.bool(forKey: key.rawValue)
    }
    
    static func getHackerUUID() -> HackerUUID? {
        if
            let publicUUID = UserDefaults.standard.string(forKey: self.publicUUIDKey),
            let privateUUID = UserDefaults.standard.string(forKey: self.privateUUIDKey) {
            return HackerUUID(publicUUID: publicUUID, privateUUID: privateUUID)
        }
        
        return nil
    }
    
    static func setUser(_ id: HackerUUID) {
        UserDefaults.standard.set(id.publicUUID, forKey: publicUUIDKey)
        UserDefaults.standard.set(id.privateUUID, forKey: privateUUIDKey)
    }
    
    static func set(value: Bool, for key: RequestKey) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
}

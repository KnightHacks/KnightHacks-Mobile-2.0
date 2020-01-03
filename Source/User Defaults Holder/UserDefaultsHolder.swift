//
//  UserDefaultsHolder.swift
//  KnightHacks
//
//  Created by Lloyd Dapaah on 12/19/19.
//  Copyright © 2019 KnightHacks. All rights reserved.
//

import UIKit

internal struct HackerUUID {
    var publicUUID: String
    var privateUUID: String
}

struct UserDefaultsHolder {
    
    private static let publicUUIDKey: String = "publicUUID"
    private static let privateUUIDKey: String = "privateUUID"
    private static let profileImageKey: String = "profileImage"
    
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
    
    static func clearHackerData() {
        UserDefaults.standard.removeObject(forKey: publicUUIDKey)
        UserDefaults.standard.removeObject(forKey: privateUUIDKey)
        UserDefaults.standard.removeObject(forKey: profileImageKey)
    }
    
    static func set(value: Bool, for key: RequestKey) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
    static func set(profileImage: UIImage) -> Bool {
        guard let data = profileImage.pngData() else {
            return false
        }
        
        UserDefaults.standard.set(data, forKey: profileImageKey)
        return true
    }
    
    static func getProfileImage() -> UIImage? {
        guard
            let imageData = UserDefaults.standard.data(forKey: profileImageKey),
            let image = UIImage(data: imageData)
        else {
            return nil
        }
        
        return image
    }
}

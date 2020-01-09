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
    var authCode: String
}

struct UserDefaultsHolder {
    
    private static let publicUUIDKey: String = "publicUUID"
    private static let authCodeKey: String = "authCodeKey"
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
            let authCode = UserDefaults.standard.string(forKey: self.authCodeKey) {
            return HackerUUID(publicUUID: publicUUID, authCode: authCode)
        }
        
        return nil
    }
    
    static func setUser(_ id: HackerUUID) {
        UserDefaults.standard.set(id.publicUUID, forKey: publicUUIDKey)
        UserDefaults.standard.set(id.authCode, forKey: authCodeKey)
    }
    
    static func clearHackerData() {
        UserDefaults.standard.removeObject(forKey: publicUUIDKey)
        UserDefaults.standard.removeObject(forKey: authCodeKey)
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

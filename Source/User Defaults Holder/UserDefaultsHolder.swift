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
    
    private static var storedProfilePictures: [String: Data]?
    
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
    
    static func exists(_ key: RequestKey) -> Bool {
        return UserDefaults.standard.value(forKey: key.rawValue) != nil
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
    
    static private func getUserDefaultsPictureDictionary() -> [String: Data] {
        guard let dictJson = UserDefaults.standard.data(forKey: profileImageKey) else {
            return [:]
        }
        
        guard let dict = try? JSONDecoder().decode([String: Data].self, from: dictJson) else {
            return [:]
        }
        
        return dict
    }
    
    static private func getStoredPictureDictionary() -> [String: Data] {
        guard let dict = self.storedProfilePictures else {
            let retrievedDictionary = getUserDefaultsPictureDictionary()
            self.storedProfilePictures = retrievedDictionary
            return retrievedDictionary
        }
        return dict
    }
    
    static func set(profileImage: UIImage, privateUUID: String) -> Bool {
        guard let data = profileImage.pngData() else {
            return false
        }
        
        var newDictionary = getStoredPictureDictionary()
        newDictionary[privateUUID] = data
        
        guard let encodedDictionary = try? JSONEncoder().encode(newDictionary) else {
            return false
        }
        
        self.storedProfilePictures = newDictionary
        UserDefaults.standard.set(encodedDictionary, forKey: profileImageKey)
        return true
    }
    
    static func getProfileImage(privateUUID: String) -> UIImage? {
        guard
            let imageData = getStoredPictureDictionary()[privateUUID],
            let image = UIImage(data: imageData)
        else {
            return nil
        }
        
        return image
    }
}

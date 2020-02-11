//
//  HackerFirebaseRequestSingleton.swift
//  KnightHacks
//
//  Created by Lloyd Dapaah on 1/20/20.
//  Copyright © 2020 KnightHacks. All rights reserved.
//

import Foundation
import Firebase

public class HackerFirebaseRequestSingleton {
    
    // get points, groups, and name
    static let databaseReference = Database.database().reference()
    static func getCompleteHackerData(input: HackerModel, completion: @escaping (HackerModel) -> Void) {
        databaseReference.child("administrative_fields").queryOrdered(byChild: "publicUuid").queryEqual(toValue: input.uuid.publicUUID).observeSingleEvent(of: .value) { (snapshot) in
            DispatchQueue.main.async {
                guard let options = snapshot.value as? [String: Any] else {
                    completion(input)
                    return
                }
                
                guard let value = options.first?.value as? [String: Any] else {
                    completion(input)
                    return
                }
                
                if let key = options.first?.key {
                    setNotificationToken(key: key, user: value)
                }
                
                var output = input
                if let foodGroup = value["foodGroup"] as? String {
                    output.foodGroup = foodGroup
                }
                
                if let pointsGroup = value["pointsGroup"] as? String {
                    output.pointsGroup = pointsGroup
                }
                
                if let pointsCount = value["pointsCount"] as? Int {
                    output.points = pointsCount
                }
                
                if let privateUUID = value["privateUuid"] as? String {
                    output.privateUUID = privateUUID
                }
                
                addHackerNameToData(input: output, completion: { (completeOutput) in
                    completion(completeOutput)
                })
            }
        }
    }
    
    static func setNotificationToken(key: String, user: [String: Any]) {
        if let appdelegate = UIApplication.shared.delegate as? AppDelegate {
            var newUserData = user
            newUserData["notificationToken"] = appdelegate.token
            databaseReference.child("administrative_fields").child(key).setValue(newUserData)
        }
    }
    
    static func addHackerNameToData(input: HackerModel, completion: @escaping (HackerModel) -> Void) {
        databaseReference.child("searchHacker").queryOrdered(byChild: "privateUuid").queryEqual(toValue: input.privateUUID).observeSingleEvent(of: .value) { (snapshot) in
            DispatchQueue.main.async {
                guard let options = snapshot.value as? [String: Any], let value = options.first?.value as? [String: Any] else {
                    completion(input)
                    return
                }
                
                var output = input
                if let name = value["name"] as? String {
                    output.name = name
                }
                
                completion(output)
            }
        }
    }
    
    // get event endtime
    static let storage = Storage.storage()
    static func getEndTime(completion: @escaping (Date?) -> Void) {
        storage.reference(withPath: "config/eventEndTime.json").getData(maxSize: 1 * 1024 * 1024) { data, error in
            DispatchQueue.main.async {
                if let error = error {
                    print(error)
                    completion(nil)
                    return
                }
                
                guard let jsonData = data else {
                    print("Error: Could not convert response to Data")
                    completion(nil)
                    return
                }
                
                guard let dictionary = try? JSONDecoder().decode([String: String].self, from: jsonData) else {
                    print("Error: Could not convert data to json")
                    completion(nil)
                    return
                }
                
                guard let format = dictionary["format"], let time = dictionary["time"] else {
                    print("Error: Could not get dictionary items")
                    completion(nil)
                    return
                }
                
                let dateFormat = DateEngine()
                dateFormat.setDateFormat(format)
                
                completion(dateFormat.getDate(from: time))
            }
        }
    }
}

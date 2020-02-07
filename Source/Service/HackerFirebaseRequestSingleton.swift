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

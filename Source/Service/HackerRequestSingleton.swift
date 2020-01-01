//
//  HackerRequestSingleton.swift
//  KnightHacks
//
//  Created by Lloyd Dapaah on 1/1/20.
//  Copyright © 2020 KnightHacks. All rights reserved.
//

import Foundation

var baseRoute: String = "https://us-central1-prackn-bad9b.cloudfunctions.net/"

internal enum HackerRequestEndpoint: String {
    case findHacker
}

internal enum HackerRequestBodyParameter: String {
    case publicUuid
    case privateUuid
}

internal class HackerRequestSingleton<Model: Codable> {
    
    func makeRequest(endpoint: HackerRequestEndpoint, body: [String: String], completion: @escaping ([String: Model]?) -> Void) {
        
        guard
            let url = URL(string: baseRoute + endpoint.rawValue),
            let jsonRequestBody = try? JSONSerialization.data(withJSONObject: body)
            else {
                completion(nil)
                return
        }
        
        var request = URLRequest(url: url)
        request.httpBody = jsonRequestBody
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { (data, _, err) in
            DispatchQueue.main.async {
                
                if let err = err {
                    print(err)
                    completion(nil)
                    return
                }
                
                guard let data = data else {
                    completion(nil)
                    return
                }
                
                completion(try? JSONDecoder().decode([String: Model].self, from: data))
            }
        }
        
        task.resume()
    }
}

// MARK: Abstraction Functions
public class HackerRequestSingletonFunction {
    
    public static func getHackerPrivateUUID(publicUUID: String, completion: @escaping (String?) -> Void) {
        let body = [HackerRequestBodyParameter.publicUuid.rawValue: publicUUID]
        HackerRequestSingleton<AdministrativeModel>().makeRequest(endpoint: .findHacker, body: body) { (hackerInfo) in
            guard let privateUUID = hackerInfo?.first?.value.privateUuid else {
                completion(nil)
                return
            }
            
            completion(privateUUID)
            return
        }
    }
}

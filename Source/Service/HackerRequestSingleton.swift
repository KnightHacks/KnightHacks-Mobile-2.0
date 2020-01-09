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
    case loginHacker
    case logoutHacker
}

internal enum HackerRequestBodyParameter: String {
    case publicUuid
    case privateUuid
    case authCode
}

internal class HackerRequestSingleton<Model: Codable> {
    
    func makeRequest(
        endpoint: HackerRequestEndpoint,
        body: [String: String],
        completion: (([String: Model]?, Int) -> Void)? = nil,
        completionWithoutID: ((Model?, Int) -> Void)? = nil) {
        
        guard
            let url = URL(string: baseRoute + endpoint.rawValue),
            let jsonRequestBody = try? JSONSerialization.data(withJSONObject: body)
            else {
                completion?(nil, -1)
                completionWithoutID?(nil, -1)
                return
        }
        
        var request = URLRequest(url: url)
        request.httpBody = jsonRequestBody
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { (data, res, err) in
            DispatchQueue.main.async {
                
                if let err = err {
                    print(err, (res as? HTTPURLResponse)?.statusCode ?? 0)
                    completion?(nil, -1)
                    completionWithoutID?(nil, -1)
                    return
                }
                
                guard let status = (res as? HTTPURLResponse)?.statusCode, status == 200 else {
                    print("Error Code: \((res as? HTTPURLResponse)?.statusCode ?? -1)")
                    completion?(nil, -1)
                    completionWithoutID?(nil, -1)
                    return
                }
                
                guard let data = data else {
                    completion?(nil, status)
                    completionWithoutID?(nil, status)
                    return
                }
                
                completion?(try? JSONDecoder().decode([String: Model].self, from: data), status)
                completionWithoutID?(try? JSONDecoder().decode(Model.self, from: data), status)
            }
        }
        
        task.resume()
    }
}

// MARK: Abstraction Functions
public class HackerRequestSingletonFunction {
    
    public static func getHackerPrivateUUID(publicUUID: String, completion: @escaping (String?) -> Void) {
        let body = [HackerRequestBodyParameter.publicUuid.rawValue: publicUUID]
        HackerRequestSingleton<AdministrativeModel>().makeRequest(endpoint: .findHacker, body: body, completion: { (hackerInfo, _) in
            guard let privateUUID = hackerInfo?.first?.value.privateUuid else {
                completion(nil)
                return
            }
            
            completion(privateUUID)
            return
        }, completionWithoutID: nil)
    }
    
    public static func loginHacker(publicUUID: String, completion: @escaping (String?) -> Void) {
        let body = [HackerRequestBodyParameter.publicUuid.rawValue: publicUUID]
        HackerRequestSingleton<AuthenticationModel>().makeRequest(endpoint: .loginHacker, body: body, completion: nil) { (authModel, _) in
            guard let authenticationCode = authModel?.authCode else {
                completion(nil)
                return
            }
            
            completion(authenticationCode)
            return
        }
    }
    
    public static func logoutHacker(publicUUID: String, authCode: String, completion: @escaping (Bool) -> Void) {
        let body = [
            HackerRequestBodyParameter.publicUuid.rawValue: publicUUID,
            HackerRequestBodyParameter.authCode.rawValue: authCode
        ]
        
        HackerRequestSingleton<Int>().makeRequest(endpoint: .logoutHacker, body: body, completion: nil) { (_, status) in
            guard status == 200 else {
                completion(false)
                return
            }
            
            completion(true)
            return
        }
    }
}

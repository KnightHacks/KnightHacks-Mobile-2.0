//
//  ImageCache.swift
//  KnightHacks
//
//  Created by Lloyd Dapaah on 8/3/19.
//  Copyright © 2019 KnightHacks. All rights reserved.
//

import UIKit

private let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImage {
    
    static func setLimit(byteCount: Int) {
        imageCache.totalCostLimit = byteCount
    }
    
    static func cacheStorageCheck(at url: String, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = imageCache.object(forKey: url as AnyObject) as? Data {
            completion(UIImage(data: cachedImage))
            return
        }
        
        completion(nil)
    }
    
    static func cacheImage(with url: String, data: Data) {
        imageCache.setObject(data as AnyObject, forKey: url as AnyObject, cost: data.count)
    }
}

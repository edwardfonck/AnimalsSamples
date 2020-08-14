//
//  ImageCache.swift
//  testing
//
//  Created by Familia Fonseca López on 06/08/20.
//  Copyright © 2020 fonseca. All rights reserved.
//

import UIKit

class ImageCache: NSCache<NSString,NSData> {
    static let shared : ImageCache = ImageCache()
    private override init () { }
    
    func cacheMy(object:Data,for key:String) {
        DispatchQueue.global(qos: .background).async {
            [weak self] in self?.setObject(object as NSData, forKey: key as NSString)
        }
    }
    
    func getMyObject(for key : NSString) -> Data? {
        return object(forKey: key) as Data?
    }
    
    func getImage(for key: String) -> UIImage? {
        if let data64 = getMyObject(for: key as NSString), let imageData = Data(base64Encoded: data64){
            return UIImage(data: imageData)
        }
        return nil
    }
    
    func getImage(for key:String) -> Data? {
        if let data64 = getMyObject(for: key as NSString) {
            return Data(base64Encoded: data64)
        }
        return nil
    }
    
    func deleteCacheObject(for key: String) {
        removeObject(forKey: key as NSString)
    }
}

//
//  PublicMethods.swift
//  AVarietyOfDemoCollection
//
//  Created by Apple on 2017/7/19.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit

class PublicMethods: NSObject {
    
    class func calculateCacheSize() -> Int? {
        var size = 0
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!
        let fileManager = FileManager.default
        guard let enumerator = fileManager.enumerator(atPath: path) else { return nil }
        while let item = enumerator.nextObject() as? String {
            let fullPath = path + "/\(item)"
            do {
                let att = try fileManager.attributesOfItem(atPath: fullPath)
                size += att[FileAttributeKey.size] as! Int
            } catch  {
                print(error.localizedDescription)
            }
        }
        return size
    }
    
    class func cleanCache() throws {
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!
        let fileManager = FileManager.default
        do {
            try fileManager.removeItem(atPath: path)
        } catch  {
            throw error
        }
    }

}

//
//  CFNetWorkCache.swift
//  multipleFrameworkDemo
//
//  Created by Apple on 2017/4/27.
//  Copyright © 2017年 cf. All rights reserved.
//

import UIKit

struct CFNetWorkCache {
    
    fileprivate let cfDickCache = CFDataBase(filePath: "cfCache")
    fileprivate let memoryCache = NSCache<AnyObject, AnyObject>()
    fileprivate let semaphore = DispatchSemaphore(value: 1)
    
    public func httpCacheForKey(key: String?) -> Data? {
        guard let nkey = key else { return nil }

        if let data = getHttpCacheFromMemory(key: nkey) {
            return data
        }
        if let data = getHttpCacheFromDisk(key: nkey) {
            return data
        }
        return nil
    }
    
    public func saveHttpCache(key: String?, value: Data?) {
        guard let nkey = key,let nvalue = value else { return }
        saveHttpCacheToMemory(key: nkey, value: nvalue)
        saveHttpCacheToDisk(key: nkey, value: nvalue)
    }
    
    fileprivate func saveHttpCacheToDisk(key: String, value: Data) {
        semaphore.wait()
        cfDickCache.insertData(name: key, data: value)
        semaphore.signal()
    }
    
    fileprivate func saveHttpCacheToMemory(key: String, value: Data) {
        memoryCache.setObject(value as AnyObject, forKey: key as AnyObject)
    }
    
    fileprivate func getHttpCacheFromMemory(key: String) -> Data? {
        return memoryCache.object(forKey: key as AnyObject) as? Data
    }
    
    fileprivate func getHttpCacheFromDisk(key: String) -> Data? {
        guard let item = cfDickCache.getItem(name: key) else { return nil }
        return item.data
    }

    
}



//
//  CFNetManager.swift
//  AVarietyOfDemoCollection
//
//  Created by Apple on 2017/5/19.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit
import Alamofire

enum NetWorkState {
    case notReach,wifi,wwan
}

class CFNetManager: NSObject {
    
    static let manager = CFNetManager()
    fileprivate let netWorkReachability = NetworkReachabilityManager(host: "www.apple.com")
    fileprivate let cfNetWorkCache = CFNetWorkCache()
    public var netWorkState = NetWorkState.notReach
    
    fileprivate override init() {}
    
    func netWorkMonitoringIsRun() {
        
        netWorkReachability?.listener = { status in
            switch status {
            case .notReachable:
                print("no net")
                self.netWorkState = .notReach
            case .unknown:
                print("unknown")
                self.netWorkState = .notReach
            case .reachable(NetworkReachabilityManager.ConnectionType.ethernetOrWiFi):
                print("wifi")
                self.netWorkState = .wifi
            case .reachable(NetworkReachabilityManager.ConnectionType.wwan):
                print("3g 4g")
                self.netWorkState = .wwan
            }
        }
        
        netWorkReachability?.startListening()
    }
    
}

extension CFNetManager {
    
    func get(url: String, success: ((Data) -> Void)?, fail: ((Error) -> Void)?) {
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).response { (response) in
            if let error = response.error {
                print(error.localizedDescription)
                if self.netWorkState == .notReach {
                    print("断网啦")
                }
                fail?(error)
            }else {
                if let data = response.data {
                    self.cfNetWorkCache.saveHttpCache(key: url, value: data)
                    success?(data)
                }
            }
        }
    }
    
    func getWithCache(url: String, needCache: Bool, updateCache: Bool, success: ((Data) -> Void)?, fail: ((Error) -> Void)?) {
        if needCache {
            if let data = cfNetWorkCache.httpCacheForKey(key: url) {
                success?(data)
                // return
            }
        }
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).response { (response) in
            if let error = response.error {
                print(error.localizedDescription)
                if self.netWorkState == .notReach {
                    print("断网啦")
                }
                fail?(error)
            }else {
                if let data = response.data {
                    if updateCache {
                        self.cfNetWorkCache.saveHttpCache(key: url, value: data)
                    }
                    success?(data)
                }
            }
        }
    }
    
    func post(url: String, parms: [String : Any]? = nil, needCache: Bool, updateCache: Bool, success: ((Data) -> Void)?, fail: ((Error) -> Void)?) {
        if needCache {
            if let data = cfNetWorkCache.httpCacheForKey(key: url) {
                success?(data)
                // return
            }
        }
        Alamofire.request(url, method: .post, parameters: parms, encoding: URLEncoding.default, headers: nil).response { (response) in
            if let error = response.error {
                print(error.localizedDescription)
                if self.netWorkState == .notReach {
                    print("断网啦")
                }
                fail?(error)
            }else {
                if let data = response.data {
                    if updateCache {
                        self.cfNetWorkCache.saveHttpCache(key: url, value: data)
                    }
                    success?(data)
                }
            }
        }
    }
}

extension CFNetManager {
    
    public func isReachable() -> Bool {
        guard let netWorkReachability = netWorkReachability else { return false }
        return netWorkReachability.isReachable
    }
    
    public func isWiFi() -> Bool {
        guard let netWorkReachability = netWorkReachability else { return false }
        return netWorkReachability.isReachableOnEthernetOrWiFi
    }
    
}

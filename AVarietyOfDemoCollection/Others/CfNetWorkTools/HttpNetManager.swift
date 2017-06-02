//
//  HttpNetManager.swift
//  multipleFrameworkDemo
//
//  Created by Apple on 2017/3/27.
//  Copyright © 2017年 cf. All rights reserved.
//

import UIKit
import Alamofire

class HttpNetManager: NSObject {
    
    enum NetWorkState {
        case notReach,wifi,wwan
    }
    
    static let manager = HttpNetManager()
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
    
    func getWithCache(url: String, success: ((Data) -> Void)?, fail: ((Error) -> Void)?) {
        if let data = cfNetWorkCache.httpCacheForKey(key: url) {
            success?(data)
           // return
        }
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).response { (response) in
            if let error = response.error {
                print(error.localizedDescription)
                if self.netWorkState == .notReach {
                    print("断网啦")
                }
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                    fail?(error)
                })
            }else {
                if let data = response.data {
                    self.cfNetWorkCache.saveHttpCache(key: url, value: data)
                    success?(data)
                }
            }
        }
        
    }
    

}

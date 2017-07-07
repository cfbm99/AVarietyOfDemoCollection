//
//  NationalGeographyViewModel.swift
//  AVarietyOfDemoCollection
//
//  Created by Apple on 2017/6/13.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit
import SwiftyJSON

class NationalGeographyViewModel: NSObject, ViewModelProtocol {
    
    dynamic var pulldownRefreshMsg: PulldownRefreshMsg = .fail
    
    var needCache: Bool = true
    var isPulldown: Bool = true
    var nowPage: Int = 1
    
    public func getLists() {
        CFNetManager.manager.getWithCache(url: "http://dili.bdatu.com/jiekou/mains/p1.html", needCache: needCache, updateCache: isPulldown, success: { (data) in
            let json = JSON(data: data)
            print(json)
        }) { (error) in
            self.pulldownRefreshMsg = .fail
        }
    }

}

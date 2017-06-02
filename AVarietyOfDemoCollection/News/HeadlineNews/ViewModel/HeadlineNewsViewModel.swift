//
//  HeadlineNewsViewModel.swift
//  AVarietyOfDemoCollection
//
//  Created by Apple on 2017/5/24.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit
import SwiftyJSON

class HeadlineNewsViewModel: NewsBaseViewModel, ViewModelProtocol {
    
    var needCache = true
    
    public func getHeadlineNews() {
        CFNetManager.manager.getWithCache(url: zolTouTiaoUrl,needCache: needCache,updateCache: self.isPulldown, success: { (data) in
            if self.isPulldown {
                self.listModels.removeAll()
            }
            guard let lists = JSON(data: data)["list"].arrayObject as? [[String : Any]],
            let pics = JSON(data: data)["pics"].arrayObject as? [[String : Any]] else { return }
            self.finishRefresh(dicArray: lists, isPulldown: self.isPulldown, complete: { (dataArray, msg) in
                if let _ = dataArray {
                    self.picModels = pics.map{ HeadlineNewsPicModel.init(dic: $0) }
                    let models = lists.map{ NewsBaseListModel.init(dic: $0)}
                    self.listModels += models
                }
                self.pulldownRefreshMsg = msg
            })
            self.needCache = false
        }) { (error) in
            self.pulldownRefreshMsg = .fail
        }
    }

}

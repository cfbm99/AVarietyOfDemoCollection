//
//  PhotographyNewsViewModel.swift
//  AVarietyOfDemoCollection
//
//  Created by Apple on 2017/6/9.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit
import SwiftyJSON

class PhotographyNewsViewModel: NewsBaseViewModel, ViewModelProtocol {
    
    var needCache = true
    
    public func getList() {
        if isPulldown {
            nowPage = 1
            eptimeDic = ("108667","1496991605840")
        }
       let url = isPulldown ? String.init(format: zolNewsUrlpulldown, zolSheYingId) : String.init(format: zolNewsUrlpullup,zolSheYingId,eptimeDic.0,eptimeDic.1,"\(nowPage)")
        CFNetManager.manager.getWithCache(url: url,needCache: needCache,updateCache: isPulldown, success: { (data) in
            guard let lists = JSON(data: data)["list"].arrayObject as? [[String : Any]] else { return }
            self.finishRefresh(dicArray: lists, isPulldown: self.isPulldown, complete: { (dataArray, msg) in
                if self.isPulldown {
                    self.listModels.removeAll()
                    if let pics = JSON(data: data)["pics"].arrayObject as? [[String : Any]] {
                        self.picModels = pics.map{ HeadlineNewsPicModel.init(dic: $0) }
                    }
                } else {
                    if let modelDic = JSON(data: data).dictionaryObject {
                        self.eptimeDic = (modelDic["ep_id"] as? String ?? "",modelDic["ep_time"] as? String ?? "")
                    }
                }
                if let _ = dataArray {
                    let models = lists.map{ NewsBaseListModel.init(dic: $0)}
                    self.listModels += models
                    if !self.needCache {
                        self.nowPage += 1
                    }
                }
                self.needCache = false
                self.pulldownRefreshMsg = msg
            })
        }) { (error) in
            self.pulldownRefreshMsg = .fail
        }
    }

}

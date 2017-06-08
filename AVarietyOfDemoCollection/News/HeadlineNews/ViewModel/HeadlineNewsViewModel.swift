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
    var tuijianLists: [HeadlineNewsTuiJianModel]!
    var sectionCountArray = [String]()
    var nowPage = 1
    var eptimeDic = ("108667","1496894408258")
    
    public func getHeadlineNews() {
        if isPulldown {
            nowPage = 1
            CFNetManager.manager.post(url: zolTouTiaoTuiJianUrl, parms: nil, needCache: false, updateCache: false, success: { (data1) in
                if self.isPulldown {
                    self.sectionCountArray.removeAll()
                }
                if let tuijian = JSON(data: data1)["list"].arrayObject as? [[String : Any]] {
                    if tuijian.count > 0 {
                        self.tuijianLists = tuijian.map{ HeadlineNewsTuiJianModel.init(dic: $0) }
                        self.sectionCountArray.append("tuijian")
                    }
                }
                self.eptimeDic = ("108667","1496894408258")
                self.getList()
            }) { (error) in
                
            }
        } else {
            getList()
        }
        
    }
    
    fileprivate func getList() {
        let url = isPulldown ? zolTouTiaoUrlpulldown : String.init(format: zolTouTiaoUrlpullup, eptimeDic.0,eptimeDic.1,"\(nowPage)")
        CFNetManager.manager.getWithCache(url: url,needCache: false,updateCache: isPulldown, success: { (data) in
            guard let lists = JSON(data: data)["list"].arrayObject as? [[String : Any]] else { return }
            self.finishRefresh(dicArray: lists, isPulldown: self.isPulldown, complete: { (dataArray, msg) in
                if self.isPulldown {
                    self.listModels.removeAll()
                    self.sectionCountArray.append("list")
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
                    self.nowPage += 1
                }
                self.needCache = false
                self.pulldownRefreshMsg = msg
            })
        }) { (error) in
            self.pulldownRefreshMsg = .fail
        }
    }
}

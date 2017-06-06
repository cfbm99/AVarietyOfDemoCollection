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
    
    var tuijianLists: [HeadlineNewsTuiJianModel]!
    var sectionCountArray = [String]()
    
    public func getHeadlineNews() {
        if isPulldown {
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
                self.getList()
            }) { (error) in
                
            }
        } else {
            getList()
        }
        
    }
    
    fileprivate func getList() {
        CFNetManager.manager.getWithCache(url: zolTouTiaoUrl,needCache: false,updateCache: self.isPulldown, success: { (data) in
            guard let lists = JSON(data: data)["list"].arrayObject as? [[String : Any]],
                let pics = JSON(data: data)["pics"].arrayObject as? [[String : Any]] else { return }
            self.finishRefresh(dicArray: lists, isPulldown: self.isPulldown, complete: { (dataArray, msg) in
                if self.isPulldown {
                    self.listModels.removeAll()
                }
                if let _ = dataArray {
                    self.picModels = pics.map{ HeadlineNewsPicModel.init(dic: $0) }
                    let models = lists.map{ NewsBaseListModel.init(dic: $0)}
                    self.listModels += models
                    self.sectionCountArray.append("list")
                }
                self.pulldownRefreshMsg = msg
            })
        }) { (error) in
            self.pulldownRefreshMsg = .fail
        }
    }
}

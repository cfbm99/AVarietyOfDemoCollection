//
//  CustomVideoPlayerViewModel.swift
//  multipleFrameworkDemo
//
//  Created by Apple on 2017/4/21.
//  Copyright © 2017年 cf. All rights reserved.
//

import UIKit
import SwiftyJSON

class CustomVideoPlayerViewModel: NewsBaseViewModel, ViewModelProtocol {
    
    fileprivate let url = "http://iphone.myzaker.com/zaker/video_tab.php?_appid=iphone&_bsize=750_1334&_city=%E6%88%90%E9%83%BD&_dev=iPhone%2C10.3.1&_lat=30.751688&_lbs_city=%E6%88%90%E9%83%BD&_lbs_province=%E5%9B%9B%E5%B7%9D&_lng=103.958136&_mac=02%3A00%3A00%3A00%3A00%3A00&_net=wifi&_udid=5A65573D-DE00-4AA9-A70F-791083C5FCCD&_uid=&_utoken=&_v=7.7&_version=7.7&act=pre&app_id=430000"
    
    fileprivate let videoUrl = "http://iphone.myzaker.com/zaker/article_mongo.php?_appid=iphone&_bsize=750_1334&app_id=%@&m=1492742642&pk=58f974347f780b6228001b4c&style_v=3"
    
    public var vedioModels = [CustomVideoPlayerModel]()
    public var videoUrlModel: CustomVideoModel!
    internal var needCache = true
    
    public func requestVideos() {
        CFNetManager.manager.getWithCache(url: url, needCache: needCache, updateCache: isPulldown, success: { (data) in
            guard let lists = JSON(data: data)["data"]["articles"].arrayObject as? [[String:Any]] else { return }
            self.finishRefresh(dicArray: lists, isPulldown: self.isPulldown, complete: { ( dataArray, msg) in
                if self.isPulldown {
                    self.vedioModels.removeAll()
                }
                if let dataArray = dataArray {
                    self.vedioModels.append(contentsOf: dataArray.map{ CustomVideoPlayerModel.init(dic: $0) })
                }
                self.pulldownRefreshMsg = msg
            })
        }) { (error) in
            self.pulldownRefreshMsg = .fail
        }
    }
    
    public func requestForVideoUrl(url:String) {
        HttpNetManager.manager.get(url: url, success: { (data) in
            guard let json = JSON(data: data, options: JSONSerialization.ReadingOptions.mutableContainers, error: nil)["data"]["video_info"].dictionaryObject else { return }
            self.videoUrlModel = CustomVideoModel.init(dic: json)
            self.requestMsg = .success
        }) { (error) in
            self.requestMsg = .fail
        }
    }

}

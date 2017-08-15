//
//  MacroDefine.swift
//  AVarietyOfDemoCollection
//
//  Created by Apple on 2017/5/18.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit

let screen_s = UIScreen.main.bounds.size

public enum ScreenSize: Int {
    case screen_3_5,screen_4,screen_4_7,screen_5_5
    
    static public func sizeForScreen() -> ScreenSize {
        let screen_s = UIScreen.main.currentMode!.size
        
        switch (screen_s.width,screen_s.height) {
        case (CGFloat(320),CGFloat(480)),((CGFloat(640),CGFloat(960))):
            return .screen_3_5
        case (CGFloat(640),CGFloat(1136)):
            return .screen_4
        case (CGFloat(750),CGFloat(1334)):
            return .screen_4_7
        default:
            return .screen_5_5
        }
    }
}

@objc public enum RequestMsg: Int {
    case success = 0, noData, fail
    
}

@objc public enum PulldownRefreshMsg: Int {
    case pulldownSuccess = 0, pulldownNoData, pullupSuccess, pullupNoData, fail
    
    
}

//*************************** 中关村api接口 ********************************

//头条
let zolTouTiaoId = "0"

let zolNewsUrlpulldown = "http://lib.wap.zol.com.cn/ipj/docList/?v=15.0&class_id=%@&isReviewing=NO&last_time=2017-06-09%2010%3A35&page=1&retina=1&vs=iph551"

let zolNewsUrlpullup = "http://lib.wap.zol.com.cn/ipj/docList/?v=15.0&class_id=%@&ep_id=%@&ep_time=%@&isReviewing=NO&last_time=&page=%@&retina=1&vs=iph561"

let dianLanGirl = "http://lib.wap.zol.com.cn/ipj/package/?v=2.0&hand_id=&pack_type=2&page=1&site_id=81"

let zolTouTiaoTuiJianUrl = "http://lib.wap.zol.com.cn/ipj/docRecommend/?v=3.0"

let detailUrl = "http://lib.wap.zol.com.cn/ipj/clientArticle/?v=4.1&fontSize=small&id=%@&picHeight=2000&picOpen=1&picWidth=500&tag=0&vs=iph561"

//摄影

let zolSheYingId = "145"

let zolSheYingUrl = "http://lib.wap.zol.com.cn/ipj/docList/?v=15.0&class_id=145&isReviewing=NO&last_time=2017-05-23%2011%3A49&page=1&retina=1&vs=iph551"
//苹果
let zolPingGuoUrl = "http://lib.wap.zol.com.cn/ipj/docList/?v=15.0&class_id=255&isReviewing=NO&last_time=2017-05-22%2022%3A27&page=1&retina=1&vs=iph551"
//新闻
let zolXinWenUrl = "http://lib.wap.zol.com.cn/ipj/docList/?v=15.0&class_id=1&isReviewing=NO&last_time=2017-05-23%2010%3A44&page=1&retina=1&vs=iph551"
//家电
let zolJiaDianUrl = "http://lib.wap.zol.com.cn/ipj/docList/?v=15.0&class_id=200&isReviewing=NO&last_time=2017-05-22%2022%3A08&page=1&retina=1&vs=iph551"
//游戏
let zolYouXiUrl = "http://lib.wap.zol.com.cn/ipj/docList/?v=15.0&class_id=16&isReviewing=NO&last_time=2017-05-22%2022%3A08&page=1&retina=1&subclass_id=&vs=iph551"
//汽车
let zolQiCheUrl = "http://lib.wap.zol.com.cn/ipj/docList/?v=15.0&class_id=357&isReviewing=NO&last_time=2017-05-23%2006%3A44&page=1&retina=1&vs=iph551"
//热榜
let zolReBangUrl = "http://lib.wap.zol.com.cn/ipj/docList/?v=15.0&class_id=8&isReviewing=NO&last_time=2017-05-24%2010%3A38&page=1&retina=1&vs=iph551"

//国家地理api
let nationalGeographyHomepageUrl = "http://dili.bdatu.com/jiekou/mains/p%d.html"
let nationalGeographyDetailUrl = "http://dili.bdatu.com/jiekou/albums/a%@.html"


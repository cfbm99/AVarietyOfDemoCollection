//
//  KaiyanEditSelectedModel.swift
//  AVarietyOfDemoCollection
//
//  Created by 曹飞 on 2017/8/16.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit
import SwiftyJSON

struct KaiyanEditSelectedModel {
    var title: String!
    var category: String!
    var coverDetail: String!
    var playUrl: String!
    var thumbPlayUrl: String!
    var duration: NSNumber!
    
    init(dic: [String : Any]) {
        category = JSON(dic)["data"]["category"].string ?? ""
        coverDetail = JSON(dic)["data"]["cover"]["detail"].string ?? ""
        duration = JSON(dic)["data"]["duration"].number ?? 0
        playUrl = JSON(dic)["data"]["playUrl"].string ?? ""
        thumbPlayUrl = JSON(dic)["data"]["thumbPlayUrl"].string ?? ""
        title = JSON(dic)["data"]["title"].string ?? ""
    }
}

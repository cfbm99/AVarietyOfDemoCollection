//
//  CustomVideoPlayerModel.swift
//  multipleFrameworkDemo
//
//  Created by Apple on 2017/4/21.
//  Copyright © 2017年 cf. All rights reserved.
//

import UIKit

struct CustomVideoPlayerModel {
    
    var title: String!
    var auther_name: String!
    var app_ids: String!
    var thumbnail_pic: String!
    var full_url: String!
    var special_info: Special_info!
    
    init(dic:[String:Any]) {
        title = dic["title"] as? String ?? ""
        auther_name = dic["auther_name"] as? String ?? ""
        app_ids = dic["app_ids"] as? String ?? ""
        thumbnail_pic = dic["thumbnail_pic"] as? String ?? ""
        full_url = dic["full_url"] as? String ?? ""
        title = dic["title"] as? String ?? ""
        guard let specailDic = dic["special_info"] as? [String:Any] else { return }
        special_info = Special_info(special_infoDic: specailDic)
    }
    
}

struct Special_info {
    var video_label: String!
    
    init(special_infoDic:[String:Any]) {
        video_label = special_infoDic["video_label"] as? String ?? ""
    }
}

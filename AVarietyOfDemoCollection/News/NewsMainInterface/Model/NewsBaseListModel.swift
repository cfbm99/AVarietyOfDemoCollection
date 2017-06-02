//
//  NewsBaseListModel.swift
//  AVarietyOfDemoCollection
//
//  Created by Apple on 2017/5/24.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit

struct NewsBaseListModel {
    
    var url: String!
    var id: String!
    var imgsrc: String!
    var sdate: String!
    var comment_num: String!
    var stitle: String!
    var type: String!
    var listStyle: String!
    
    
    init(dic:[String : Any]) {
        url = dic["url"] as? String ?? ""
        id = dic["id"] as? String ?? ""
        imgsrc = dic["imgsrc"] as? String ?? ""
        stitle = dic["stitle"] as? String ?? ""
        comment_num = dic["comment_num"] as? String ?? ""
        type = dic["type"] as? String ?? ""
        listStyle = dic["listStyle"] as? String ?? ""
        sdate = dic["sdate"] as? String ?? ""
    }

}

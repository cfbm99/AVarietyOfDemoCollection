//
//  HeadlineNewsPicModel.swift
//  AVarietyOfDemoCollection
//
//  Created by Apple on 2017/5/24.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit

struct HeadlineNewsPicModel {
    
    var url: String!
    var id: String!
    var imgsrc: String!
    var stitle: String!
    
    init(dic:[String : Any]) {
        url = dic["url"] as? String ?? ""
        id = dic["id"] as? String ?? ""
        imgsrc = dic["imgsrc"] as? String ?? ""
        stitle = dic["stitle"] as? String ?? ""
    }

}

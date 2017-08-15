//
//  CustomVideoModel.swift
//  multipleFrameworkDemo
//
//  Created by Apple on 2017/4/21.
//  Copyright © 2017年 cf. All rights reserved.
//

import UIKit

struct CustomVideoModel {
    
    var url: String!
    
    init(dic:[String:Any]) {
        url = dic["url"] as? String ?? ""
    }
}

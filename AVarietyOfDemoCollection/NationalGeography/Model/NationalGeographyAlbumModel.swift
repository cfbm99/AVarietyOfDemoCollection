//
//  NationalGeographyAlbumModel.swift
//  AVarietyOfDemoCollection
//
//  Created by Apple on 2017/7/11.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit

struct NationalGeographyAlbumModel {
    
    var id: String
    var title: String
    var picModel: [NationalGeographyPicModel] = []
    
    init(dic: [String : Any]) {
        id = dic["id"] as? String ?? " "
        title = dic["title"] as? String ?? " "
    }
}

struct NationalGeographyPicModel {
    var id: String
    var url: String
    var title: String
    var content: String
    
    init(dic: [String : Any]) {
        id = dic["id"] as? String ?? " "
        url = dic["url"] as? String ?? " "
        title = dic["title"] as? String ?? " "
        content = dic["content"] as? String ?? " "
    }
}

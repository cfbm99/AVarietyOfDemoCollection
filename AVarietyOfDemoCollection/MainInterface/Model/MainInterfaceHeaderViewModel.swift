//
//  MainInterfaceHeaderViewModel.swift
//  AVarietyOfDemoCollection
//
//  Created by Apple on 2017/5/19.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit

class MainInterfaceHeaderViewModel: NSObject {

}

struct MainInterfaceHeaderAlbumModel {
    var id: String!
    
    init(dic: [String : Any]) {
        id = dic["id"] as? String ?? " "
    }
    
}

struct MainInterfaceHeaderImageModel {
    var id: String!
    var thumb: String!
    var yourshotlink: String!
    
    init(dic: [String : Any]) {
        id = dic["id"] as? String ?? " "
        thumb = dic["thumb"] as? String ?? " "
        yourshotlink = dic["yourshotlink"] as? String ?? " "
    }
}

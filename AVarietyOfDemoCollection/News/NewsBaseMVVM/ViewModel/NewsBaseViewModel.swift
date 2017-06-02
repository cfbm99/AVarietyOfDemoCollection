//
//  NewsBaseViewModel.swift
//  AVarietyOfDemoCollection
//
//  Created by Apple on 2017/5/24.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit

class NewsBaseViewModel: NSObject {
    
    dynamic var requestMsg: RequestMsg = .fail
    dynamic var pulldownRefreshMsg: PulldownRefreshMsg = .fail
    
    var isPulldown = true
    
    var picModels: [HeadlineNewsPicModel]?
    var listModels = [NewsBaseListModel]()

}

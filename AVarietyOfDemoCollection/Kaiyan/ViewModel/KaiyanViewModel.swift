//
//  KaiyanViewModel.swift
//  AVarietyOfDemoCollection
//
//  Created by Apple on 2017/8/9.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit
import SwiftyJSON

class KaiyanViewModel: NSObject, ViewModelprotocol {
    
    var nowPage: Int = 1
    var pulldown: Bool = true
    dynamic var requestByPulldownDidFinishState: RequestByPulldownDidFinishState = .fail
    public var modelList: Array<KaiyanEditSelectedModel> = []
    
    fileprivate var date: String {
        let timeInterval = Date().timeIntervalSince1970 * 1000
        return String.init(format: "%.0f", timeInterval)
    }

    fileprivate var url: String {
        return String.init(format: "http://baobab.kaiyanapp.com/api/v4/tabs/selected?date=%@&num=%@&page=%@", date, "\(nowPage)", "\(nowPage)")
    }
    
    public func requestForKaiyanDataList() {
        HttpNetManager.manager.requestWithGet(by: url, cache: { (cache) in
            
        }, success: { (data) in
            guard let dicArray = JSON(data: data)["itemList"].arrayObject as? [[String : Any]] else { return }
            self.finishRequestWithPulldown(by: dicArray, complte: { (array, state) in
                if let dics = array {
                    self.modelList.append(contentsOf: dics.map({ KaiyanEditSelectedModel.init(dic: $0) }))
                }
                self.requestByPulldownDidFinishState = state
            })
        }) { (error) in
            
        }
    }

}

//
//  NationalGeographyViewModel.swift
//  AVarietyOfDemoCollection
//
//  Created by Apple on 2017/6/13.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit
import SwiftyJSON

class NationalGeographyViewModel: NSObject, ViewModelProtocol {
    
    dynamic var pulldownRefreshMsg: PulldownRefreshMsg = .pulldownSuccess
    
    var nationalModelList: [NationalGeographyAlbumModel] = []
    var needCache: Bool = true
    var isPulldown: Bool = true
    var nowPage: Int = 1
    
    public func getLists() {
        if isPulldown {
            nowPage = 1
        }
        CFNetManager.manager.get(by: String.init(format: nationalGeographyHomepageUrl, nowPage), cache: { (cache) in
            
        }, success: { (data) in
            guard let album = JSON(data: data)["album"].arrayObject as? [[String : Any]] else { return }
            var albumModels = album.map({ NationalGeographyAlbumModel.init(dic: $0) })
            var dicArray: Array<[[String : Any]]> = Array()
            let group = DispatchGroup()
            for (_, model) in albumModels.enumerated() {
                group.enter()
                CFNetManager.manager.get(by: String.init(format: nationalGeographyDetailUrl, model.id), cache: { (cache) in
                    
                }, success: { (data) in
                    guard let detail = JSON(data: data)["picture"].arrayObject as? [[String : Any]] else { return }
                    dicArray.append(detail)
                    group.leave()
                }, fail: { (error) in
                    self.pulldownRefreshMsg = .fail
                    return
                })
            }
            group.notify(queue: DispatchQueue.main, execute: {
                self.didFinishRefresh(by: dicArray, isPulldown: self.isPulldown, complete: { (haveData, msg) in
                    if self.isPulldown {
                        self.nationalModelList.removeAll()
                    }
                    if haveData {
                        let picModels = dicArray.map({ (dics) -> [NationalGeographyPicModel] in
                            let models = dics.map({ NationalGeographyPicModel.init(dic: $0) })
                            return models
                        })
                        for (idx, pics) in picModels.enumerated() {
                            albumModels[idx].picModel = pics
                        }
                        self.nowPage += 1
                        self.nationalModelList += albumModels
                    }
                    self.pulldownRefreshMsg = msg
                })
            })
        }) { (error) in
            self.pulldownRefreshMsg = .fail
        }
    }
    
    fileprivate func dealJsonData(data: Data) {
        
    }
}

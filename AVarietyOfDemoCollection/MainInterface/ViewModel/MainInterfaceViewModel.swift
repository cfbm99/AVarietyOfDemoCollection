//
//  MainInterfaceViewModel.swift
//  AVarietyOfDemoCollection
//
//  Created by Apple on 2017/5/19.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit
import SwiftyJSON

class MainInterfaceViewModel: NSObject, ViewModelProtocol {
    var isPulldown: Bool = false
    var nowPage: Int = 1
    var needCache: Bool = false
    
    dynamic var requestMsg: RequestMsg = .fail

    var headerViewsModels: [MainInterfaceHeaderImageModel]?
    
    public func getMainInterfaceHeaderViews() {
        CFNetManager.manager.get(url: "http://dili.bdatu.com/jiekou/mains/p1.html", success: { (data1) in
            guard let album0 = JSON(data: data1)["album"][1].dictionaryObject else { return }
            let albumModel: MainInterfaceHeaderAlbumModel = MainInterfaceHeaderAlbumModel.init(dic: album0)
            CFNetManager.manager.get(url: String.init(format: "http://dili.bdatu.com/jiekou/albums/a%@.html", albumModel.id), success: { (data2) in
                guard let pictures = JSON(data2)["picture"].arrayObject as? [[String : Any]] else { return }
                self.finishRequest(dicArray: pictures, complete: { (dics, msg) in
                    if let dics = dics {
                        self.headerViewsModels = dics.map{MainInterfaceHeaderImageModel.init(dic: $0)}
                    }
                    self.requestMsg = msg
                })
            }, fail: { (error) in
                self.requestMsg = .fail
            })
        }) { (error) in
            self.requestMsg = .fail
        }
    }
    
}

//
//  Extensions.swift
//  AVarietyOfDemoCollection
//
//  Created by Apple on 2017/5/18.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit

protocol ViewModelProtocol {
    
    func finishRequest(dicArray: [[String : Any]], complete: (([[String : Any]]?, RequestMsg) -> Void)?)
    
    func finishRefresh(dicArray: [[String : Any]], isPulldown: Bool, complete: (([[String : Any]]?, PulldownRefreshMsg) -> Void)?)
}

extension ViewModelProtocol {
    
    func finishRequest(dicArray: [[String : Any]], complete: (([[String : Any]]?, RequestMsg) -> Void)?) {
        if dicArray.count > 0 {
            complete?(dicArray, .success)
        }else {
            complete?(nil, .noData)
        }
    }
    
    func finishRefresh(dicArray: [[String : Any]], isPulldown: Bool, complete: (([[String : Any]]?, PulldownRefreshMsg) -> Void)?) {
        if isPulldown {
            if dicArray.count > 0 {
                complete?(dicArray, .pulldownSuccess)
            }else {
                complete?(dicArray, .pulldownNoData)
            }
        }else {
            if dicArray.count > 0 {
                complete?(dicArray, .pullupSuccess)
            }else {
                complete?(dicArray, .pullupNoData)
            }
        }
    }
}

extension UITableView {
    
    func reloadRequestData(change: [NSKeyValueChangeKey : Any]) {
        
    }
    
    func reloadRefreshData(change: [NSKeyValueChangeKey : Any]) {
        if let header = cf_header {
            if header.isRefresh() {
                header.endRefresh()
            }
        }
        
        guard let value = change[.newKey] as? NSNumber,
            let msg = PulldownRefreshMsg(rawValue: value.intValue) else { return }
        
        switch msg {
        case .pulldownSuccess:
            reloadData()
        case .pulldownNoData:
            print("no data")
        case .pullupSuccess:
            reloadData()
        case .pullupNoData:
            print("no more data")
        case .fail:
            print("fail")
        }
    }
}

extension UILabel {
    var fontsizeToFit: CGFloat {
        get {
            return font.pointSize
        }
        set {
            var size = newValue
            if ScreenSize.sizeForScreen() == .screen_3_5 || ScreenSize.sizeForScreen() == .screen_4 {
                size -= 2
            }else if ScreenSize.sizeForScreen() == .screen_3_5 {
                size += 100
            }
            font = UIFont.systemFont(ofSize: size)
        }
    }
}

extension UIButton {
    var fontsizeToFit: CGFloat {
        get {
            return titleLabel!.font.pointSize
        }
        set {
            var size = newValue
            if ScreenSize.sizeForScreen() == .screen_3_5 || ScreenSize.sizeForScreen() == .screen_4 {
                size -= 2
            }else if ScreenSize.sizeForScreen() == .screen_3_5 {
                size += 1.5
            }
            titleLabel?.font = UIFont.systemFont(ofSize: size)
        }
    }
}

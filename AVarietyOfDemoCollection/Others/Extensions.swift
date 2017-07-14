//
//  Extensions.swift
//  AVarietyOfDemoCollection
//
//  Created by Apple on 2017/5/18.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit
import MJRefresh

protocol ViewModelProtocol {
    
    var needCache: Bool { get set }
    var isPulldown: Bool { get set }
    var nowPage: Int { get set }
    
    func finishRequest(dicArray: [[String : Any]], complete: (([[String : Any]]?, RequestMsg) -> Void)?)
    
    func finishRefresh(dicArray: [[String : Any]], isPulldown: Bool, complete: (([[String : Any]]?, PulldownRefreshMsg) -> Void)?)
    
    func didFinishRefresh<T>(by array: [T], isPulldown: Bool, complete: ((Bool, PulldownRefreshMsg) -> Void)?)
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
                complete?(nil, .pulldownNoData)
            }
        }else {
            if dicArray.count > 0 {
                complete?(dicArray, .pullupSuccess)
            }else {
                complete?(nil, .pullupNoData)
            }
        }
    }
    
    func didFinishRefresh<T>(by array: [T], isPulldown: Bool, complete: ((Bool, PulldownRefreshMsg) -> Void)?) {
        if isPulldown {
            if array.count > 0 {
                complete?(true, .pulldownSuccess)
            }else {
                complete?(false, .pulldownNoData)
            }
        }else {
            if array.count > 0 {
                complete?(true, .pullupSuccess)
            }else {
                complete?(false, .pullupNoData)
            }
        }
    }
}

extension UITableView {
    
    func reloadRequestData(change: [NSKeyValueChangeKey : Any]) {
        
    }
    
    func reloadRefreshData(change: [NSKeyValueChangeKey : Any]?, pulldownSuccess: (() -> Void)? = nil) {
        if let header = self.mj_header {
            if header.isRefreshing() {
                header.endRefreshing()
            }
        }
        if let footer = self.cf_footer {
            if footer.isRefresh() {
                footer.endRefresh()
            }
        }
        if let msgValue = change?[.newKey] as? NSNumber,
            let msg = PulldownRefreshMsg(rawValue: msgValue.intValue) {
            
            switch msg {
            case .pulldownSuccess:
                pulldownSuccess?()
                self.reloadData()
            case .pullupSuccess:
                self.reloadData()
            default:
                break
            }
        }
    }
    
    func addRefreshHeaderAndFooter(headerClosure: (() -> Void)?, footerClosure: (() -> Void)?) {
        self.estimatedRowHeight = 80
        self.rowHeight = UITableViewAutomaticDimension
        if let _ = headerClosure {
            self.mj_header = CFArrowRefreshHeader(refreshingBlock: { 
                headerClosure?()
            })
        }
        if let footer = footerClosure {
            self.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { 
                footer()
            })
        }
    }
    
    func reloadDataByRefresh(by msg: Any?, pulldownSuccess: (() -> Void)?, fail: (() -> Void)?) {
        if let header = self.mj_header {
            if header.isRefreshing() {
                header.endRefreshing()
            }
        }
        if let footer = self.mj_footer {
            if footer.isRefreshing() {
                footer.endRefreshing()
            }
        }
        guard let msgValue = msg as? NSNumber, let pullMsg = PulldownRefreshMsg(rawValue: msgValue.intValue) else { return }
        switch pullMsg {
        case .pulldownSuccess:
            mj_footer.resetNoMoreData()
            pulldownSuccess?()
            reloadData()
        case .pulldownNoData:
            reloadData()
        case .pullupSuccess:
            reloadData()
        case .pullupNoData:
            self.mj_footer.endRefreshingWithNoMoreData()
        case .fail:
            fail?()
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

extension Date {
    func convertDateToString(dateFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let dateStr = dateFormatter.string(from: self)
        return dateStr
    }
}

extension UIColor {
    func colorForImage(size:CGSize) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, true, 0)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(self.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

extension Double {
    func setPlayTime() -> String {
        let date:Date = NSDate.init(timeIntervalSince1970: TimeInterval(self)) as Date
        let formatter = DateFormatter()
        if self / 3600 >= 1 {
            formatter.dateFormat = "HH:mm:ss"
        }else{
            formatter.dateFormat = "mm:ss"
        }
        let result = formatter.string(from: date)
        return result
    }
}

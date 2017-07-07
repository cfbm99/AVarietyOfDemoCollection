//
//  Extensions.swift
//  AVarietyOfDemoCollection
//
//  Created by Apple on 2017/5/18.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit

protocol ViewModelProtocol {
    
    var needCache: Bool { get set }
    var isPulldown: Bool { get set }
    var nowPage: Int { get set }
    
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
    
    func reloadRefreshData(change: [NSKeyValueChangeKey : Any]?, pulldownSuccess: (() -> Void)? = nil) {
        if let header = self.cf_header {
            if header.isRefresh() {
                header.endRefresh()
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

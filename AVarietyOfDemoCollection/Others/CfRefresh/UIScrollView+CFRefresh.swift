//
//  UIScrollView+CFRefresh.swift
//  multipleFrameworkDemo
//
//  Created by Apple on 2017/5/5.
//  Copyright © 2017年 cf. All rights reserved.
//

import UIKit

var key1: Void?
var key2: Void?

extension UIScrollView {
    
    var cf_header: CFRefreshHeader? {
        get {
            return objc_getAssociatedObject(self, &key1) as? CFRefreshHeader
        }
        set {
            if let header = self.cf_header,let newView = newValue {
                if newValue != header {
                    header.removeFromSuperview()
                    self.insertSubview(newView, at: 0)
                    objc_setAssociatedObject(self, &key1, newValue, .OBJC_ASSOCIATION_ASSIGN)
                }
            }else if let newView = newValue {
                self.insertSubview(newView, at: 0)
                objc_setAssociatedObject(self, &key1, newValue, .OBJC_ASSOCIATION_ASSIGN)
            }
        }
    }
    
    
    
}

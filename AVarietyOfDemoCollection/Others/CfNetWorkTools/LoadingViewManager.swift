//
//  LoadingViewManager.swift
//  AVarietyOfDemoCollection
//
//  Created by Apple on 2017/6/9.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit

class LoadingViewManager: NSObject {
    
    static let manager = LoadingViewManager()
    
    var loadingView: UIView?
    
    private override init() {
        super.init()
    }
    
    public func showLoadingView(color: UIColor? = nil, toView: UIView) {
        let width = toView.frame.width / 10
        let orignX = toView.frame.width * 0.45
        let orignY = (toView.frame.height - width) / 2
        
        let ldView: LoadingView = LoadingView(frame: CGRect(x: orignX, y: orignY, width: width, height: width))
        ldView.animationLayer.strokeColor = color?.cgColor ?? UIColor.white.cgColor
        toView.addSubview(ldView)
        loadingView = ldView
    }
    
    public func hideLoadingView() {
        if let loadV = loadingView {
            loadV.removeFromSuperview()
        }
    }
    
    
}

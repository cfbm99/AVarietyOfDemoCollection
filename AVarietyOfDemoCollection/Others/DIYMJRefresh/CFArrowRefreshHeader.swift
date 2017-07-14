//
//  CFArrowRefreshHeader.swift
//  AVarietyOfDemoCollection
//
//  Created by Apple on 2017/7/7.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit
import MJRefresh

class CFArrowRefreshHeader: MJRefreshHeader {

    lazy var arrow: UIImageView = {
        let imageV: UIImageView = UIImageView(image: Bundle.mj_arrowImage())
        imageV.tintColor = UIColor.black
        return imageV
    }()
    
    lazy var indicatorView: UIActivityIndicatorView = {
        let view: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        return view
    }()
    
    override var state: MJRefreshState {
        didSet {
            if state == .idle {
                if oldValue == .refreshing {
                    arrow.transform = CGAffineTransform.identity
                    UIView.animate(withDuration: 0.3, animations: { 
                        self.indicatorView.alpha = 0
                    }, completion: { (finish) in
                        self.indicatorView.stopAnimating()
                        self.indicatorView.alpha = 1
                        self.arrow.isHidden = false
                    })
                } else {
                    indicatorView.stopAnimating()
                    arrow.isHidden = false
                    UIView.animate(withDuration: 0.3, animations: { 
                        self.arrow.transform = CGAffineTransform.identity
                    })
                }
            } else if state == .pulling {
                indicatorView.stopAnimating()
                arrow.isHidden = false
                UIView.animate(withDuration: 0.3, animations: {
                    self.arrow.transform = CGAffineTransform.init(rotationAngle: CGFloat.pi)
                })
            } else if state == .refreshing {
                indicatorView.alpha = 1
                indicatorView.startAnimating()
                arrow.isHidden = true
            }
        }
    }
    
    override func prepare() {
        super.prepare()
        self.addSubview(indicatorView)
        self.addSubview(arrow)
    }
    
    override func placeSubviews() {
        super.placeSubviews()
        let centerX = self.mj_w / 2
        let centerY = self.mj_h / 2
        arrow.center = CGPoint(x: centerX, y: centerY)
        indicatorView.center = CGPoint(x: centerX, y: centerY)
    }
    
}

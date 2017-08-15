//
//  CFRefreshNormalHeader.swift
//  multipleFrameworkDemo
//
//  Created by Apple on 2017/5/12.
//  Copyright © 2017年 cf. All rights reserved.
//

import UIKit
import SnapKit

class CFRefreshNormalHeader: CFRefreshHeader {
    
    lazy var titleLb: UILabel = {
        let label: UILabel = UILabel()
        label.textAlignment = .center
        label.fontsizeToFit = 12
        return label
    }()
    
    override var state: CFRefreshComponent.CFRefreshState {
        didSet {
            if state == .idle {
                if oldValue == .refreshing {
                    titleLb.text = "刷新成功"
                    UIView.animate(withDuration: 0.3, animations: {
                        self.scrollView.contentInset.top = 0
                    }, completion: { (finish) in
                        self.titleLb.text = "下拉刷新"
                    })
                }else {
                    titleLb.text = "下拉刷新"
                }
            }else if state == .pulling {
                titleLb.text = "松开即可刷新"
            }else if state == .refreshing {
                titleLb.text = "刷新中"
                UIView.animate(withDuration: 0.3, animations: {
                    self.scrollView.contentInset.top = self.bounds.height
                }, completion: { (finish) in
                    self.refreshingClosure?()
                })
            }
        }
    }
    
    override func prepare() {
        super.prepare()
        self.addSubview(titleLb)
        titleLb.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
    
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

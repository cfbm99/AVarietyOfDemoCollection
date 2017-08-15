//
//  CFRefreshHeader.swift
//  multipleFrameworkDemo
//
//  Created by Apple on 2017/5/5.
//  Copyright © 2017年 cf. All rights reserved.
//

import UIKit

class CFRefreshHeader: CFRefreshComponent {

    init(refreshClosure: (() -> Void)?) {
        super.init(frame: CGRect.zero)
        refreshingClosure = refreshClosure
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        super.prepare()
        //self.backgroundColor = UIColor.yellow
        self.frame = CGRect(x: 0, y: -50, width: 0, height: 50)
    }
}

extension CFRefreshHeader {
    override func scrollViewContentOffsetDidChange(change: [NSKeyValueChangeKey : Any]?) {
        guard let value = change?[.newKey] as? NSValue,let scrollV = scrollView else { return }
        let offsetY = value.cgPointValue.y
        if offsetY > 0 {
            return
        }
        let nomarl2pullingOffsetY = scrollV.contentInset.top - self.bounds.height
        let _ = -offsetY / self.bounds.height
        if scrollV.isDragging {
            if state == .idle && offsetY < nomarl2pullingOffsetY {
                state = .pulling
            }else if state == .pulling && offsetY > nomarl2pullingOffsetY {
                state = .idle
            }
        }else if state == .pulling {
            beginRefresh()
        }
        
    }
    
}

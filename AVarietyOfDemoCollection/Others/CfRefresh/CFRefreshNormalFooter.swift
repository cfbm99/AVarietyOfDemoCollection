//
//  CFRefreshNormalFooter.swift
//  AVarietyOfDemoCollection
//
//  Created by Apple on 2017/6/6.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit

class CFRefreshNormalFooter: CFRefreshComponent {
    
    lazy var titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textAlignment = .center
        label.fontsizeToFit = 12
        return label
    }()
    
    override var state: CFRefreshComponent.CFRefreshState {
        didSet {
            if state == .idle {
                if oldValue == .refreshing {
                    titleLabel.text = "刷新成功"
                    UIView.animate(withDuration: 0.3, animations: {
                        self.scrollView.contentInset.bottom = 0
                    }, completion: { (finish) in
                        self.titleLabel.text = "上拉刷新"
                    })
                } else {
                    titleLabel.text = "上拉刷新"
                }
            } else if state == .pulling {
                titleLabel.text = "松开即可刷新"
            } else if state == .refreshing {
                titleLabel.text = "刷新中"
                UIView.animate(withDuration: 0.3, animations: { 
                    self.scrollView.contentInset.bottom = self.bounds.height
                }, completion: { (finish) in
                    self.refreshingClosure?()
                })
            }
        }
    }
    
    init(refreshClosure: (() -> Void)? = nil) {
        super.init(frame: CGRect.zero)
        refreshingClosure = refreshClosure
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        super.prepare()
        var frame = self.frame
        frame.size.height = 50
        self.frame = frame
        
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
    
    override func scrollViewContentSizeDidChange(change: [NSKeyValueChangeKey : Any]?) {
        guard let value = change?[.newKey] as? NSValue else { return }
        let contentHeight = value.cgSizeValue.height
        let scrollViewHeight = self.scrollView!.bounds.height
        
        var frame = self.frame
        frame.origin.y = max(contentHeight, scrollViewHeight)
        self.frame = frame
    }
    
    override func scrollViewContentOffsetDidChange(change: [NSKeyValueChangeKey : Any]?) {
        if state == .refreshing {
            return
        }
        guard let value = change?[.newKey] as? NSValue else { return }
        let offsetY = value.cgPointValue.y
        
        if offsetY < canSeeOffsetY() {
            return
        }
        if state == .noMoreData {
            return
        }
        
        let normal2pullingOffsetY = canSeeOffsetY() + self.bounds.height
        
        if scrollView.isDragging {
            if state == .idle && offsetY > normal2pullingOffsetY {
                state = .pulling
            } else if state == .pulling && offsetY < normal2pullingOffsetY {
                state = .idle
            }
        } else if state == .pulling {
            beginRefresh()
        }
        
    }
    
    func canSeeOffsetY() -> CGFloat {
        let h = scrollView.contentSize.height - scrollView.bounds.height
        
        if h > 0 {
            return h
        } else {
            return scrollView.contentInset.top
        }
    }

}

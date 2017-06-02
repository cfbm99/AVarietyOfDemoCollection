//
//  CFRefreshComponent.swift
//  multipleFrameworkDemo
//
//  Created by Apple on 2017/5/5.
//  Copyright © 2017年 cf. All rights reserved.
//

import UIKit

class CFRefreshComponent: UIView {
    
    enum CFRefreshState {
        case idle,pulling,refreshing,willRefresh
    }
    
    public var refreshingClosure: (() -> Void)?
    public var state: CFRefreshState = .idle
    public var scrollView: UIScrollView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepare()
        state = .idle
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func prepare() {
        self.backgroundColor = UIColor.clear
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        removeKvo()
        guard let newSuperView = newSuperview else { return }
        if !newSuperView.isKind(of: UIScrollView.self) {
            return
        }
        var newFrame = self.frame
        newFrame.size.width = newSuperView.bounds.width
        newFrame.origin.x = 0
        self.frame = newFrame
        scrollView = newSuperView as? UIScrollView
        scrollView?.alwaysBounceVertical = true
        addKvo()
    }
    
    deinit {
        print("destroy header")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

extension CFRefreshComponent {
    
    fileprivate func addKvo() {
        scrollView?.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
        scrollView?.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    fileprivate func removeKvo() {
        scrollView?.removeObserver(self, forKeyPath: "contentOffset")
        scrollView?.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentOffset" {
            scrollViewContentOffsetDidChange(change: change)
        }
    }
    
    public func scrollViewContentOffsetDidChange(change: [NSKeyValueChangeKey: Any]?) {
        
    }
    
}

extension CFRefreshComponent {
    
    public func beginRefresh() {
        self.state = .refreshing
    }
    
    public func endRefresh() {
        self.state = .idle
    }
    
    public func isRefresh() -> Bool {
        return state == .refreshing
    }
    
}


//
//  UITableView_Extension.swift
//  AVarietyOfDemoCollection
//
//  Created by 曹飞 on 2017/8/16.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit
import MJRefresh

extension UITableView {
    
    func reloadByRequestData(state: RequestDidFinishState, complete: (() -> Void)? = nil) {
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
        if state == .success {
            complete?()
            reloadData()
        } else if state == .successWithNoData {
            reloadData()
        }
    }
    
    func reloadByRequestWithPulldown(state: RequestByPulldownDidFinishState, complte: (() -> Void)?) {
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
        switch state {
        case .pulldownSuccess:
            mj_footer.resetNoMoreData()
            complte?()
            reloadData()
        case .pulldownSuccessWithNoData:
            reloadData()
        case .pullupSuccess:
            reloadData()
        case .pullupSuccessWithNoData:
            self.mj_footer.endRefreshingWithNoMoreData()
        default: break
            
        }
    }

}

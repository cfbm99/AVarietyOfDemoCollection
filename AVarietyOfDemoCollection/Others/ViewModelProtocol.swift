//
//  ViewModelProtocol.swift
//  AVarietyOfDemoCollection
//
//  Created by 曹飞 on 2017/8/16.
//  Copyright © 2017年 Apple. All rights reserved.
//

import Foundation

@objc protocol ViewModelprotocol: NSObjectProtocol {
    
    @objc optional var requestByPulldownDidFinishState: RequestByPulldownDidFinishState { set get }
    @objc optional var requestDidFinishState: RequestDidFinishState { set get }
    @objc optional var nowPage: Int { set get }
    @objc optional var pulldown: Bool { set get }
    
    
    @objc optional func finishRequest(by dicArray: [[String : Any]], complte: (([[String : Any]]?, RequestDidFinishState) -> Void)?)
    
    @objc optional func finishRequestWithPulldown(by dicArray: [[String : Any]], complte: (([[String : Any]]?, RequestByPulldownDidFinishState) -> Void)?)
    
}

extension ViewModelprotocol {
    
    func finishRequest(by dicArray: [[String : Any]], complte: (([[String : Any]]?, RequestDidFinishState) -> Void)?) {
        if dicArray.count > 0 {
            complte?(dicArray, .success)
        } else {
            complte?(nil, .successWithNoData)
        }
    }
    
    func finishRequestWithPulldown(by dicArray: [[String : Any]], complte: (([[String : Any]]?, RequestByPulldownDidFinishState) -> Void)?) {
        guard let pulldown = pulldown else { return }
        if pulldown {
            if dicArray.count > 0 {
                complte?(dicArray, .pulldownSuccess)
            } else {
                complte?(nil, .pulldownSuccessWithNoData)
            }
        } else {
            if dicArray.count > 0 {
                complte?(dicArray, .pullupSuccess)
            } else {
                complte?(nil, .pullupSuccessWithNoData)
            }
        }
    }
}

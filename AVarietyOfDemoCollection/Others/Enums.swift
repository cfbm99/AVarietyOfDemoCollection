//
//  Enums.swift
//  AVarietyOfDemoCollection
//
//  Created by 曹飞 on 2017/8/16.
//  Copyright © 2017年 Apple. All rights reserved.
//

import Foundation

@objc enum RequestByPulldownDidFinishState: Int {
    case pulldownSuccess = 1, pulldownSuccessWithNoData, pullupSuccess, pullupSuccessWithNoData, fail
}

@objc enum RequestDidFinishState: Int {
    case success = 1, successWithNoData, fail
}

enum DeviceScreenSize: Int {
    case screen_4_0 = 1, screen_4_7, screen_5_5
    
    static func calculateScreenSize() ->DeviceScreenSize {
        let screen_s = UIScreen.main.currentMode!.size
        switch (screen_s.width, screen_s.height) {
        case (CGFloat(640),CGFloat(1136)):
            return .screen_4_0
        case (CGFloat(750),CGFloat(1334)):
            return .screen_4_7
        default:
            return .screen_5_5
        }
    }
}

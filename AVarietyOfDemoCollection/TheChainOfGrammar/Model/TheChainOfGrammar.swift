//
//  TheChainOfGrammar.swift
//  AVarietyOfDemoCollection
//
//  Created by Apple on 2017/7/4.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit

class Calculator: NSObject {
    var sum: CGFloat = 0
    lazy var add: (CGFloat) -> Calculator = {[weak self] (num: CGFloat) -> Calculator in
        self?.sum += num
        return self!
    }

    lazy var subtract: (CGFloat) -> Calculator = {[weak self] (num: CGFloat) -> Calculator in
        self?.sum -= num
        return self!
    }
    
    override init() {
        
    }
    
    
}

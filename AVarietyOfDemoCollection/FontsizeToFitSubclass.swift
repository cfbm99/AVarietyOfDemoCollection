//
//  FontsizeToFitSubclass.swift
//  AVarietyOfDemoCollection
//
//  Created by Apple on 2017/5/18.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit

class fontsizeToFitLabel: UILabel {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fontsizeToFit = font.pointSize
    }
}

class fontsizeToFitButton: UIButton {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fontsizeToFit = titleLabel!.font.pointSize
    }
}

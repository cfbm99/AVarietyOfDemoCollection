//
//  CustomVideoPalyerSlider.swift
//  multipleFrameworkDemo
//
//  Created by 曹飞 on 2017/4/23.
//  Copyright © 2017年 cf. All rights reserved.
//

import UIKit

class CustomVideoPalyerSlider: UISlider {
    
    public var dragSliderClosure: ((Bool) -> Void)?
    
    public lazy var progressView:UIProgressView = {
        let view = UIProgressView.init(progressViewStyle: UIProgressViewStyle.default)
        view.progress = 0
        view.progressTintColor = #colorLiteral(red: 0.6642242074, green: 0.6642400622, blue: 0.6642315388, alpha: 1)
        view.trackTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.isUserInteractionEnabled = false
        return view
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.insertSubview(progressView, at: 0)
    }

    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        let oldFrame = super.trackRect(forBounds: bounds)
        progressView.frame = CGRect(x: oldFrame.origin.x, y: oldFrame.origin.y, width: oldFrame.size.width, height: 2)
        return CGRect(x: oldFrame.origin.x, y: oldFrame.origin.y, width: oldFrame.size.width, height: 2)
    }
    
    override func thumbRect(forBounds bounds: CGRect, trackRect rect: CGRect, value: Float) -> CGRect {
        let oldFrame = super.thumbRect(forBounds: bounds, trackRect: rect, value: value)
        return CGRect(x: oldFrame.origin.x, y: oldFrame.origin.y, width: screen_s.width * 0.032, height: screen_s.width * 0.032)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        dragSliderClosure?(true)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        dragSliderClosure?(false)
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

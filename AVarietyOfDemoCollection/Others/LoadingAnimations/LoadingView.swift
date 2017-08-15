//
//  LoadingView.swift
//  multipleFrameworkDemo
//
//  Created by coffee on 2017/1/3.
//  Copyright © 2017年 cf. All rights reserved.
//

import UIKit

class LoadingView: UIView {
    
    lazy var animationLayer:CAShapeLayer = {
        let layer = CAShapeLayer()
        let path = UIBezierPath.init(arcCenter: CGPoint.init(x: self.bounds.width / 2, y: self.bounds.width / 2), radius: self.bounds.width / 2, startAngle: -CGFloat.pi / 2, endAngle: CGFloat.pi / 2 * 3, clockwise: true)
        layer.strokeColor = UIColor.red.cgColor
        layer.lineWidth = 2
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeEnd = 0
        layer.path = path.cgPath
        return layer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.addSublayer(animationLayer)
        animationLayer.add(animationForLayer(), forKey: nil)
        self.layer.add(rotateAnimation(), forKey: nil)
    }
    
    func animationForLayer() -> CAAnimationGroup {
        let animation1 = CABasicAnimation.init(keyPath: "strokeEnd")
        animation1.fromValue = 0
        animation1.toValue = 0.8
        animation1.duration = 1

        let animation2 = CABasicAnimation.init(keyPath: "strokeStart")
        animation2.fromValue = -0.8
        animation2.toValue = 0.8
        animation2.beginTime = 1
        animation2.duration = 0.8
        
        let group = CAAnimationGroup()
        group.animations = [animation1,animation2]
        group.duration = 1.8
        group.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        group.repeatCount = HUGE
        group.isRemovedOnCompletion = false
        animation1.fillMode = kCAFillModeForwards
        return group
    }
    
    func rotateAnimation() -> CABasicAnimation{
        let rotate = CABasicAnimation.init(keyPath: "transform.rotation.z")
        rotate.toValue = CGFloat.pi * 2
        rotate.duration = 0.9
        rotate.repeatCount = HUGE
        rotate.isRemovedOnCompletion = false
        rotate.fillMode = kCAFillModeBackwards
        return rotate
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}


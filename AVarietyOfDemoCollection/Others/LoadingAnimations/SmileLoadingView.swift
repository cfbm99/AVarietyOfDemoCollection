//
//  SmileLoadingView.swift
//  multipleFrameworkDemo
//
//  Created by coffee on 2017/1/11.
//  Copyright © 2017年 cf. All rights reserved.
//

/*
 圆点坐标：(x0,y0)
 半径：r
 角度：a0
 
 则圆上任一点为：（x1,y1）
 x1   =   x0   +   r   *   cos(ao   *   3.14   /180   )
 y1   =   y0   +   r   *   sin(ao   *   3.14   /180   )
 */

import UIKit

class SmileLoadingView: UIView {
    
    lazy var animationLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        let path = UIBezierPath(arcCenter: self.myCenter, radius: (self.bounds.width / 2) - 10, startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: true)
        layer.path = path.cgPath
        layer.strokeColor = UIColor.green.cgColor
        layer.lineCap = kCALineCapRound
        layer.lineWidth = 6
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeEnd = 0.5
        return layer
    }()
    
    lazy var myCenter:CGPoint = {
        return CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2)
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeInterface()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initializeInterface(){
        self.backgroundColor = UIColor.white
        self.layer.addSublayer(animationLayer)
        self.layer.add(rotateAnimation(), forKey: nil)
        animationLayer.add(smileAnimation(), forKey: nil)
    }
    
    func smileAnimation() -> CAAnimationGroup {
        let group = CAAnimationGroup()
        let animation1 = CABasicAnimation(keyPath: "strokeEnd")
        animation1.toValue = 0.87
        animation1.duration = 0.7
        animation1.isRemovedOnCompletion = false
        animation1.fillMode = kCAFillModeForwards
        let animation2 = CABasicAnimation(keyPath: "strokeEnd")
        animation2.beginTime = 0.8
        animation2.duration = 0.7
        animation2.toValue = 0.5
        animation2.isRemovedOnCompletion = false
        animation2.fillMode = kCAFillModeForwards
        group.animations = [animation1,animation2]
        group.duration = 2
        group.repeatCount = HUGE
        return group
    }
    
    func rotateAnimation() -> CABasicAnimation {
        let rotate = CABasicAnimation(keyPath: "transform.rotation")
        rotate.duration = 2
        rotate.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
        rotate.toValue = M_PI * 4
        rotate.repeatCount = HUGE
        return rotate
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        let ref = UIGraphicsGetCurrentContext()
        let x1 = myCenter.x + ((self.bounds.width / 2) - 10) * cos(CGFloat(-M_PI_4))
        let y1 = myCenter.y + ((self.bounds.width / 2) - 10) * sin(CGFloat(-M_PI_4))
        ref?.addArc(center: CGPoint.init(x: x1, y: y1), radius: 3, startAngle: 0, endAngle: CGFloat(M_PI) * 2, clockwise: true)
        ref?.setFillColor(UIColor.green.cgColor)
        ref?.drawPath(using: CGPathDrawingMode.fill)
        let x2 = myCenter.x + ((self.bounds.width / 2) - 10) * cos(CGFloat(M_PI + M_PI_4))
        let y2 = myCenter.y + ((self.bounds.width / 2) - 10) * sin(CGFloat(M_PI + M_PI_4))
        ref?.addArc(center: CGPoint.init(x: x2, y: y2), radius: 3, startAngle: 0, endAngle: CGFloat(M_PI * 2), clockwise: true)
        ref?.setFillColor(UIColor.green.cgColor)
        ref?.drawPath(using: CGPathDrawingMode.fill)
    }
    

}

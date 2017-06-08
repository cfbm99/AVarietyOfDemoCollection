//
//  CaRelicatorLayerAnimation.swift
//  multipleFrameworkDemo
//
//  Created by Apple on 2017/4/18.
//  Copyright © 2017年 cf. All rights reserved.
//

import UIKit

class CaRelicatorLayerAnimation: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.addSublayer(addLayerAnimation())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addLayerAnimation() -> CALayer {
        let width: CGFloat = 50/4
        let transX: CGFloat = 50 - width
        let shapeLayer = CAShapeLayer()
        shapeLayer.backgroundColor = UIColor.red.cgColor
        shapeLayer.bounds = CGRect(x: 0, y: 0, width: width, height: width)
        let replicateLayer = CAReplicatorLayer()
        replicateLayer.addSublayer(shapeLayer)
        replicateLayer.frame = CGRect(x: 0, y: 0, width: width, height: width)
        var transform3D = CATransform3DIdentity
        transform3D = CATransform3DMakeTranslation(transX, 0, 0)
        transform3D = CATransform3DRotate(transform3D, CGFloat(Double.pi/180 * 120), 0, 0, 1)
        replicateLayer.instanceTransform = transform3D
        replicateLayer.instanceCount = 3
        replicateLayer.instanceDelay = 0
        replicateLayer.instanceGreenOffset = 0.3
        shapeLayer.add(scaleAnimation(), forKey: nil)
        return replicateLayer
    }
    
    func scaleAnimation() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "transform")
        let fromValue = CATransform3DRotate(CATransform3DIdentity, 0, 0, 0, 0)
        animation.fromValue = fromValue
        var toValue = CATransform3DTranslate(CATransform3DIdentity, 50 - 50/4, 0, 0)
        toValue = CATransform3DRotate(toValue, CGFloat(Double.pi/3 * 2), 0, 0, 1)
        animation.toValue = toValue
        animation.autoreverses = false
        animation.duration = 0.8
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.repeatCount = HUGE
        return animation
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

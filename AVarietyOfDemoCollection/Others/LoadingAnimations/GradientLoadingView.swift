//
//  GradientLoadingView.swift
//  multipleFrameworkDemo
//
//  Created by Apple on 2017/3/20.
//  Copyright © 2017年 cf. All rights reserved.
//

import UIKit

class GradientLoadingView: UIView {
    
    lazy var shapeLayer: CAShapeLayer = {
        let layer: CAShapeLayer = CAShapeLayer()
        let path = UIBezierPath(arcCenter: CGPoint.init(x: self.bounds.size.width / 2, y: self.bounds.size.width / 2), radius: self.bounds.size.width / 2.8, startAngle: 0, endAngle: CGFloat(M_PI * 2), clockwise: true)
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.red.cgColor
        layer.lineWidth = 3
        layer.path = path.cgPath
        return layer
    }()
    
    lazy var gradientLayer: CAGradientLayer = {
        let layer: CAGradientLayer = CAGradientLayer()
        layer.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.width)
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 1, y: 1)
        layer.locations = [0.2,0.4,1]
        layer.colors = [#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).cgColor,#colorLiteral(red: 0.2689321319, green: 0.2689321319, blue: 0.2689321319, alpha: 1).cgColor,#colorLiteral(red: 0.9708469133, green: 0.9708469133, blue: 0.9708469133, alpha: 1).cgColor]
        layer.mask = self.shapeLayer
        return layer
    }()
    
    lazy var titleLb: UILabel = {
        let label: UILabel = UILabel()
        label.frame = CGRect(x: 0, y: self.bounds.size.width, width: self.bounds.size.width, height: self.bounds.size.height - self.bounds.size.width)
        label.font = UIFont.systemFont(ofSize: 8)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeInterface()
    }
    
    func rotationAniamtion() -> CABasicAnimation {
        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.duration = 2
        rotation.repeatCount = HUGE
        rotation.fromValue = 0
        rotation.toValue = M_PI * 2
        rotation.isRemovedOnCompletion = false
        rotation.fillMode = kCAFillModeForwards
        return rotation
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initializeInterface() {
        self.layer.addSublayer(gradientLayer)
        self.addSubview(titleLb)
        self.gradientLayer.add(rotationAniamtion(), forKey: nil)
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

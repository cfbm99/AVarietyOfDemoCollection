//
//  CubeRotationViewController.swift
//  AVarietyOfDemoCollection
//
//  Created by Apple on 2017/6/9.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit

class CubeRotationViewController: UIViewController {
    
    lazy var diceView: UIView = {
        let diceView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: screen_s.width / 2, height: screen_s.width / 2))
        diceView.backgroundColor = UIColor.clear
        diceView.center = self.view.center
        
        let imageV1 = UIImageView(frame: diceView.bounds)
        imageV1.image = #imageLiteral(resourceName: "dice1")
        diceView.addSubview(imageV1)
        
        let panGesture: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(scrollBlueView))
        diceView.addGestureRecognizer(panGesture)
        return diceView
    }()
    
    var anglePoint = CGPoint(x: 0, y: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeInterface()
        // Do any additional setup after loading the view.
    }
    
    func initializeInterface() {
        view.backgroundColor = UIColor.white
        view.addSubview(diceView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension CubeRotationViewController {
    func scrollBlueView(pan: UIPanGestureRecognizer) {
        let point = pan.translation(in: pan.view)
        let angleX = anglePoint.x + point.x * CGFloat.pi / 180
        let angleY = anglePoint.y - point.y * CGFloat.pi / 180
        
        if pan.state == .began {
            
        } else if pan.state == .changed {
            var rotation = CATransform3DIdentity
            rotation.m34 = 1/500
            rotation = CATransform3DRotate(rotation, angleX, 0, 1, 0)
            rotation = CATransform3DRotate(rotation, angleY, 1, 0, 0)
            diceView.layer.sublayerTransform = rotation
        } else if pan.state == .ended {
            anglePoint.x = angleX
            anglePoint.y = angleY
        }
    }
}

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
        var transformDice = CATransform3DIdentity
        
        let imageV1 = UIImageView(frame: diceView.bounds)
        imageV1.image = #imageLiteral(resourceName: "dice1")
        imageV1.layer.transform = CATransform3DTranslate(transformDice, 0, 0, screen_s.width / 4)
        diceView.addSubview(imageV1)
        
        let imageV6 = UIImageView(frame: diceView.bounds)
        imageV6.image = #imageLiteral(resourceName: "dice6")
        transformDice = CATransform3DIdentity
        imageV6.layer.transform = CATransform3DTranslate(transformDice, 0, 0, -screen_s.width / 4)
        diceView.addSubview(imageV6)
        
        let imageV2 = UIImageView(frame: diceView.bounds)
        imageV2.image = #imageLiteral(resourceName: "dice2")
        transformDice = CATransform3DRotate(CATransform3DIdentity, CGFloat.pi / 2, 0, 1, 0)
        transformDice = CATransform3DTranslate(transformDice, 0, 0, screen_s.width / 4)
        imageV2.layer.transform = transformDice
        diceView.addSubview(imageV2)
        
        let imageV5 = UIImageView(frame: diceView.bounds)
        imageV5.image = #imageLiteral(resourceName: "dice5")
        transformDice = CATransform3DRotate(CATransform3DIdentity, CGFloat.pi / 2, 0, 1, 0)
        transformDice = CATransform3DTranslate(transformDice, 0, 0, -screen_s.width / 4)
        imageV5.layer.transform = transformDice
        diceView.addSubview(imageV5)
        
        let imageV3 = UIImageView(frame: diceView.bounds)
        imageV3.image = #imageLiteral(resourceName: "dice3")
        transformDice = CATransform3DRotate(CATransform3DIdentity, -CGFloat.pi / 2, 1, 0, 0)
        transformDice = CATransform3DTranslate(transformDice, 0, 0, screen_s.width / 4)
        imageV3.layer.transform = transformDice
        diceView.addSubview(imageV3)
        
        let imageV4 = UIImageView(frame: diceView.bounds)
        imageV4.image = #imageLiteral(resourceName: "dice4")
        transformDice = CATransform3DRotate(CATransform3DIdentity, -CGFloat.pi / 2, 1, 0, 0)
        transformDice = CATransform3DTranslate(transformDice, 0, 0, -screen_s.width / 4)
        imageV4.layer.transform = transformDice
        diceView.addSubview(imageV4)
        
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
        title = "CubeRotation"
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
            rotation.m34 = -1/500
            rotation = CATransform3DRotate(rotation, angleX, 0, 1, 0)
            rotation = CATransform3DRotate(rotation, angleY, 1, 0, 0)
            diceView.layer.sublayerTransform = rotation
        } else if pan.state == .ended {
            anglePoint.x = angleX
            anglePoint.y = angleY
        }
    }
}

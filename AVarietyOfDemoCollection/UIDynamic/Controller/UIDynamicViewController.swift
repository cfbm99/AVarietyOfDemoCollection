//
//  UIDynamicViewController.swift
//  AVarietyOfDemoCollection
//
//  Created by Apple on 2017/7/7.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit

class UIDynamicViewController: UIViewController {

    let behavior = UIDynamicBehavior()
    
    lazy var gravity: UIGravityBehavior = {
        let gravity: UIGravityBehavior = UIGravityBehavior()
        gravity.gravityDirection = CGVector(dx: 0, dy: 1)
        return gravity
    }()
    
    lazy var dynamicAnimator: UIDynamicAnimator = {
        let dynamicAnimator = UIDynamicAnimator(referenceView: self.view)
        return dynamicAnimator
    }()
    
    lazy var collision: UICollisionBehavior = {
        let collision: UICollisionBehavior = UICollisionBehavior()
        collision.setTranslatesReferenceBoundsIntoBoundary(with: UIEdgeInsets.zero)
        return collision
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initializeInterface()
    }
    
    func initializeInterface() {
        view.backgroundColor = UIColor.white
        dynamicAnimator.addBehavior(behavior)
        behavior.addChildBehavior(gravity)
        behavior.addChildBehavior(collision)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let position = touch.location(in: view)
        let imageV = UIImageView(frame: CGRect(x: 100, y: 100, width: 60, height: 60))
        imageV.center = position
        imageV.layer.cornerRadius = 30;
        imageV.backgroundColor = UIColor(red: CGFloat(arc4random_uniform(255)) / 255.0, green: CGFloat(arc4random_uniform(255)) / 255.0, blue: CGFloat(arc4random_uniform(255)) / 255.0, alpha: 1)
        view.addSubview(imageV)
        gravity.addItem(imageV)
        collision.addItem(imageV)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  NationalGeographyDetailViewController.swift
//  AVarietyOfDemoCollection
//
//  Created by Apple on 2017/7/14.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit

class NationalGeographyDetailViewController: UIViewController {
    
    fileprivate lazy var scollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.frame = CGRect(x: 0, y: 0, width: screen_s.width + 20, height: screen_s.height)
        scroll.backgroundColor = UIColor.black
        scroll.isPagingEnabled = true
        scroll.contentSize = CGSize(width: (screen_s.width + 20) * CGFloat(self.nationalModelList.count), height: screen_s.height)
        return scroll
    }()
    
    var nationalModelList: [NationalGeographyPicModel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initializeInterface()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeInterface() {
        view.addSubview(scollView)
        addSubViews()
    }
    
    fileprivate func addSubViews() {
        for (idx, model) in nationalModelList.enumerated() {
            let subView: NationalGeographyPicView = NationalGeographyPicView(frame: CGRect(x: (screen_s.width + 20) * CGFloat(idx), y: 0, width: screen_s.width, height: screen_s.height))
            subView.model = model
            scollView.addSubview(subView)
        }
    }

}

extension NationalGeographyDetailViewController: UIScrollViewDelegate {
    
    
    
}


//
//  KaiyanViewController.swift
//  AVarietyOfDemoCollection
//
//  Created by Apple on 2017/8/9.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit

class KaiyanViewController: UIViewController {
    
    let viewModel = KaiyanViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rac_binding()
        viewModel.requestForKaiyanDataList()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        print("kaiyan deinit")
    }
    
}

extension KaiyanViewController {
    
    fileprivate func rac_binding() {
        viewModel.reactive.signal(forKeyPath: "requestByPulldownDidFinishState").observeValues {[weak self] (state) in
            print(self!.viewModel.modelList)
        }
    
    }
}

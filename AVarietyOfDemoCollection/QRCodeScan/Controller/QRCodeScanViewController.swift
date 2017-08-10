//
//  QRCodeScanViewController.swift
//  AVarietyOfDemoCollection
//
//  Created by Apple on 2017/8/8.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit

class QRCodeScanViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initializeInterface()
    }
    
    func initializeInterface() {
        view.backgroundColor = UIColor.white
        let scanView = CFQRCodeScanView(frame: view.bounds, title: "123")
        scanView.delegate = self
        view.addSubview(scanView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension QRCodeScanViewController: CFQRCodeScanViewDelegate {
    func didFinishScan(with result: String) {
        print(result)
    }
}

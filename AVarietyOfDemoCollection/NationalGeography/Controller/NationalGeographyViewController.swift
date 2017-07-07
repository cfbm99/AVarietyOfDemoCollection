//
//  NationalGeographyViewController.swift
//  AVarietyOfDemoCollection
//
//  Created by Apple on 2017/6/13.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit

class NationalGeographyViewController: UIViewController {
    
    let viewModel = NationalGeographyViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func initializeInterface() {
        viewModel.getLists()
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

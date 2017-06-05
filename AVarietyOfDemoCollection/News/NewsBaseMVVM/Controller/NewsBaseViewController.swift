//
//  NewsBaseViewController.swift
//  AVarietyOfDemoCollection
//
//  Created by Apple on 2017/5/23.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit
import SnapKit

protocol NewsBaseViewControllerDelegate: NSObjectProtocol {
    
    func tableViewDidScroll(offsetY: CGFloat)
}

class NewsBaseViewController: UIViewController {
    
    public lazy var tableV: UITableView = {
        let table: UITableView = UITableView(frame: self.view.bounds, style: .grouped)
        table.register(UINib.init(nibName: "NewsBaseTableViewCell", bundle: nil), forCellReuseIdentifier: "NewsBaseTableViewCell")
        table.register(UINib.init(nibName: "NewsBaseStyle2TableViewCell", bundle: nil), forCellReuseIdentifier: "NewsBaseStyle2TableViewCell")
        table.estimatedRowHeight = 80
        table.rowHeight = UITableViewAutomaticDimension
        return table
    }()
    
    weak var delegate: NewsBaseViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeInterface()
        // Do any additional setup after loading the view.
    }
    
    func initializeInterface() {
        view.addSubview(tableV)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension NewsBaseViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == tableV {
            let offsetY = scrollView.panGestureRecognizer.translation(in: scrollView).y
            if offsetY < -10 || offsetY > 10{
                delegate?.tableViewDidScroll(offsetY: offsetY)
            }
        }
    }
}

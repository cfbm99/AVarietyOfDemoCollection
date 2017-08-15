//
//  MainInterfaceCollectionViewCell.swift
//  AVarietyOfDemoCollection
//
//  Created by Apple on 2017/5/19.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit

class MainInterfaceCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var zhanweiLb: FontsizeToFitLabel!
    @IBOutlet weak var titleLb: FontsizeToFitLabel!
    @IBOutlet weak var imageV: UIImageView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.snp.makeConstraints { (make) in
            make.width.equalTo(screen_s.width / 3)
        }
    }
    

}

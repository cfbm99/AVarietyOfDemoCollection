//
//  NationalGeographyCollectionViewCell.swift
//  AVarietyOfDemoCollection
//
//  Created by Apple on 2017/7/14.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit

class NationalGeographyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageV: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.snp.makeConstraints { (make) in
            make.width.equalTo((screen_s.width - 41) / 3)
        }
    }
    
}

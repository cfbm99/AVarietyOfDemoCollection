//
//  NewsTitlesCollectionViewCell.swift
//  AVarietyOfDemoCollection
//
//  Created by Apple on 2017/5/23.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit

class NewsTitlesCollectionViewCell: UICollectionViewCell {
    
    public lazy var titleLb: UILabel = {
        let label: UILabel = UILabel(frame: self.bounds)
        label.fontsizeToFit = 13
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(titleLb)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

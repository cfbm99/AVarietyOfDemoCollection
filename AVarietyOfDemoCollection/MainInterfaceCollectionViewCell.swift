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
    @IBOutlet weak var imageVWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageVTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var zhanweiLbBottomConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageVTopConstraint.constant = screen_s.width / 3 / 6
        zhanweiLbBottomConstraint.constant = screen_s.width / 3 / 6
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        self.layoutIfNeeded()
        let size = contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        var newFrame = layoutAttributes.frame
        newFrame.size.height = size.height
        newFrame.size.width = screen_s.width / 3
        layoutAttributes.frame = newFrame
        return layoutAttributes
    }

}

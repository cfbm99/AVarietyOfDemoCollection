//
//  WheelPlayCollectionViewCell.swift
//  multipleFrameworkDemo
//
//  Created by Apple on 2017/1/13.
//  Copyright © 2017年 cf. All rights reserved.
//

import UIKit
import SDWebImage

class WheelPlayCollectionViewCell: UICollectionViewCell {
    
    lazy var imageV:UIImageView = {
        let view = UIImageView.init(frame: self.bounds)
        view.contentMode = UIViewContentMode.scaleAspectFill
        return view
    }()
    
    var imgName:String!{
        didSet{
            guard let url = URL.init(string: imgName) else { return }
            imageV.sd_setImage(with: url)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeInterface()
    }
    
    func initializeInterface(){
        contentView.addSubview(imageV)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

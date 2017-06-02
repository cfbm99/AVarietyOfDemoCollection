//
//  NewsBaseTableViewCell.swift
//  AVarietyOfDemoCollection
//
//  Created by Apple on 2017/5/23.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit

class NewsBaseTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageV: UIImageView!
    @IBOutlet weak var titleLb: fontsizeToFitLabel!
    @IBOutlet weak var dateLb: fontsizeToFitLabel!
    
    public var model: NewsBaseListModel! {
        didSet {
            titleLb.text = model.stitle
            dateLb.text = model.sdate
            guard let url = URL.init(string: model.imgsrc) else { return }
            imageV.sd_setImage(with: url)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

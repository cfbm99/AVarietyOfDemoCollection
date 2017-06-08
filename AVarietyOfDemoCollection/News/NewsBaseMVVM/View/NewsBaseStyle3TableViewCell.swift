//
//  NewsBaseStyle3TableViewCell.swift
//  AVarietyOfDemoCollection
//
//  Created by Apple on 2017/6/7.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit

class NewsBaseStyle3TableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLb: FontsizeToFitLabel!
    @IBOutlet weak var dateLb: FontsizeToFitLabel!
    @IBOutlet var imageV: [UIImageView]!
    
    public var model: NewsBaseListModel! {
        didSet {
            titleLb.text = model.stitle
            dateLb.text = model.sdate
            if let images = model.pics {
                for (idx, imageV) in imageV.enumerated() {
                    guard let url = URL.init(string: images[idx]) else { return }
                    imageV.sd_setImage(with: url)
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        if highlighted {
            self.contentView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        } else {
            self.contentView.backgroundColor = UIColor.white
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

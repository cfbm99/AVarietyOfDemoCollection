//
//  NewsBaseStyle2TableViewCell.swift
//  AVarietyOfDemoCollection
//
//  Created by Apple on 2017/6/2.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit

class NewsBaseStyle2TableViewCell: UITableViewCell {

    @IBOutlet weak var titleLb: FontsizeToFitLabel!
    @IBOutlet weak var imageV: UIImageView!
    @IBOutlet weak var dateLb: FontsizeToFitLabel!
    
    public var model: NewsBaseListModel! {
        didSet {
            titleLb.text = model.stitle
            dateLb.text = model.sdate
            guard let url = URL.init(string: model.bigPicture) else { return }
            imageV.sd_setImage(with: url)
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

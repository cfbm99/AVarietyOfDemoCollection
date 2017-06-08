//
//  CustomVideoPlayerTableViewCell.swift
//  multipleFrameworkDemo
//
//  Created by Apple on 2017/4/21.
//  Copyright © 2017年 cf. All rights reserved.
//

import UIKit

class CustomVideoPlayerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLb: FontsizeToFitLabel!
    @IBOutlet weak var imageV: UIImageView!
    @IBOutlet weak var subTitleLb: FontsizeToFitLabel!
    @IBOutlet weak var timeLb: UILabel!
    var model: CustomVideoPlayerModel! {
        didSet {
            guard let url = URL.init(string: model.thumbnail_pic) else { return }
            imageV.sd_setImage(with: url)
            titleLb.text = model.title
            subTitleLb.text = model.auther_name
            timeLb.text = model.special_info.video_label
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        separatorInset = UIEdgeInsetsMake(0, 10, 0, 10)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

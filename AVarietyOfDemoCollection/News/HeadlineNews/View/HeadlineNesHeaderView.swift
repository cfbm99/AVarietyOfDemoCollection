//
//  HeadlineNesHeaderView.swift
//  AVarietyOfDemoCollection
//
//  Created by Apple on 2017/6/5.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit

class HeadlineNesHeaderView: UITableViewHeaderFooterView {
    
    lazy var label: UILabel = {
        let label: UILabel = UILabel()
        label.text = "为你推荐"
        label.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        label.fontsizeToFit = 13
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(-5)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

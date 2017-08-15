//
//  NewsTitlesView.swift
//  AVarietyOfDemoCollection
//
//  Created by Apple on 2017/5/23.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit

protocol NewsTitlesViewDelegate: NSObjectProtocol {
    func didSelectTitle(_ title: String, index: IndexPath)
}

class NewsTitlesView: UIView {
    
    weak var delegate: NewsTitlesViewDelegate?
    
    lazy var collectionV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: screen_s.width / 7, height: 34)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets.zero
        layout.scrollDirection = .horizontal
        let view: UICollectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        view.backgroundColor = UIColor.white
        view.register(NewsTitlesCollectionViewCell.self, forCellWithReuseIdentifier: "NewsTitlesCollectionViewCell")
        view.alwaysBounceHorizontal = true
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    lazy var markLine: UILabel = {
        let mark: UILabel = UILabel()
        mark.frame = CGRect(x: 0, y: self.collectionV.frame.height - 3, width: screen_s.width / 7, height: 3)
        mark.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        return mark
    }()
    
    fileprivate lazy var line: UILabel = {
        let line: UILabel = UILabel()
        line.frame = CGRect(x: 0, y: self.bounds.height - 0.5, width: screen_s.width, height: 0.5)
        line.backgroundColor = #colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1)
        return line
    }()
    
    public var titlesArray: [String]? {
        didSet {
            collectionV.reloadData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(collectionV)
        collectionV.addSubview(markLine)
        self.addSubview(line)
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

extension NewsTitlesView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titlesArray?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: NewsTitlesCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsTitlesCollectionViewCell", for: indexPath) as? NewsTitlesCollectionViewCell else { fatalError("no cell") }
        cell.titleLb.text = titlesArray?[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let title = titlesArray![indexPath.row]
        UIView.animate(withDuration: 0.3) { 
            self.markLine.transform = CGAffineTransform.init(translationX: CGFloat(indexPath.row) * screen_s.width / 7, y: 0)
        }
        delegate?.didSelectTitle(title, index: indexPath)
    }
}

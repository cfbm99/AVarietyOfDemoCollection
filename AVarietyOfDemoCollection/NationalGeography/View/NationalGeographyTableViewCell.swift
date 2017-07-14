//
//  NationalGeographyTableViewCell.swift
//  AVarietyOfDemoCollection
//
//  Created by Apple on 2017/7/14.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit

protocol NationalGeographyTableViewCellDelegate: NSObjectProtocol {
    func didSelectCell(cell: NationalGeographyCollectionViewCell, albumModel: NationalGeographyAlbumModel, indexPath: IndexPath)
}

class NationalGeographyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var picCollectionView: UICollectionView!
    @IBOutlet weak var picLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var titleLb: FontsizeToFitLabel!
    
    weak var delegate: NationalGeographyTableViewCellDelegate?
    
    var albumModel: NationalGeographyAlbumModel! {
        didSet {
            if let first = albumModel.picModel.first {
                titleLb.text = "\(albumModel.title) \(first.title)"
            }
            picCollectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initializeInterface()
    }
    
    func initializeInterface() {
        picLayout.estimatedItemSize = CGSize(width: 100, height: 100)
        picLayout.sectionInset = UIEdgeInsets.zero
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension NationalGeographyTableViewCell {
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        picLayout.invalidateLayout()
        layoutIfNeeded()
        let height = picLayout.collectionViewContentSize.height
        return CGSize(width: screen_s.width, height: height + titleLb.frame.height + 30)
    }
    
}

extension NationalGeographyTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albumModel.picModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: NationalGeographyCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "NationalGeographyCollectionViewCell", for: indexPath) as! NationalGeographyCollectionViewCell
        let model: NationalGeographyPicModel = albumModel.picModel[indexPath.row]
        if let url = URL.init(string: model.url) {
            cell.imageV.sd_setImage(with: url)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? NationalGeographyCollectionViewCell else { return }
        delegate?.didSelectCell(cell: cell, albumModel: albumModel, indexPath: indexPath)
    }
}

//
//  CFPhotoBrowseViewController.swift
//  AVarietyOfDemoCollection
//
//  Created by 曹飞 on 2017/7/15.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit

class CFPhotoBrowseViewController: UIViewController {
    
    fileprivate lazy var collectionV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: screen_s.width, height: screen_s.height)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 20
        let collectionV = UICollectionView(frame: CGRect(x: 0, y: 0, width: screen_s.width + 20, height: screen_s.height), collectionViewLayout: layout)
        collectionV.register(CFPhotoBrowseCollectionViewCell.self, forCellWithReuseIdentifier: "CFPhotoBrowseCollectionViewCell")
        collectionV.isPagingEnabled = true
        collectionV.dataSource = self
        return collectionV
    }()
    
    var imgUrls: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeInterface()
        // Do any additional setup after loading the view.
    }
    
    func initializeInterface() {
        view.addSubview(collectionV)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension CFPhotoBrowseViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: CFPhotoBrowseCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CFPhotoBrowseCollectionViewCell", for: indexPath) as? CFPhotoBrowseCollectionViewCell else { fatalError("no cell") }
        cell.imgUrl = imgUrls[indexPath.row]
        cell.delegate = self
        return cell
    }
}

extension CFPhotoBrowseViewController: CFPhotoBrowseCollectionViewCellDelegate {
    
    func dismissVc(by indexPath: IndexPath, imageV: UIImageView) {
        print(indexPath.row)
        self.dismiss(animated: true, completion: nil)
    }
}

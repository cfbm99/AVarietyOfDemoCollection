//
//  CFPhotoBrowseCollectionViewCell.swift
//  AVarietyOfDemoCollection
//
//  Created by 曹飞 on 2017/7/15.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit
import SDWebImage

protocol CFPhotoBrowseCollectionViewCellDelegate: NSObjectProtocol {
    func dismissVc(by indexPath: IndexPath, imageV: UIImageView)
}

class CFPhotoBrowseCollectionViewCell: UICollectionViewCell {
    
    weak var delegate: CFPhotoBrowseCollectionViewCellDelegate?
    
    lazy var imageV: UIImageView = {
        let imageV = UIImageView()
        imageV.contentMode = .scaleAspectFill
        imageV.clipsToBounds = true
        imageV.isUserInteractionEnabled = true
        return imageV
    }()
    
    lazy var backScollView: UIScrollView = {
        let scroll: UIScrollView = UIScrollView(frame: self.bounds)
        scroll.minimumZoomScale = 1
        scroll.maximumZoomScale = 2
        scroll.delegate = self
        return scroll
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(backScollView)
        backScollView.addSubview(imageV)
        addGestures()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var imgUrl: String! {
        didSet {
            guard let url = URL.init(string: imgUrl) else { return }
            loadingImage(url: url)
        }
    }
    
    fileprivate func loadingImage(url: URL) {
        SDWebImageManager.shared().downloadImage(with: url, options: [.retryFailed, .refreshCached], progress: nil) { (image, error, type, finish, url) in
            if let img = image {
                let scale = img.size.width * img.scale / screen_s.width
                self.imageV.bounds = CGRect(x: 0, y: 0, width: screen_s.width, height: img.size.height / scale)
                self.imageV.center = CGPoint(x: screen_s.width / 2, y: screen_s.height / 2)
                self.imageV.image = img
            }
        }
    }
}

extension CFPhotoBrowseCollectionViewCell: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageV
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        imageV.center = CGPoint(x: screen_s.width / 2, y: screen_s.height / 2)
    }
    
}

extension CFPhotoBrowseCollectionViewCell {
    
    fileprivate func addGestures() {
        let singleGesture = UITapGestureRecognizer(target: self, action: #selector(singleAction))
        let doubleGesture = UITapGestureRecognizer(target: self, action: #selector(doubleAction))
        doubleGesture.numberOfTapsRequired = 2
        singleGesture.require(toFail: doubleGesture)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panAction))
        
        backScollView.addGestureRecognizer(singleGesture)
        backScollView.addGestureRecognizer(doubleGesture)
        backScollView.addGestureRecognizer(panGesture)
    }
    
    func singleAction(tap: UITapGestureRecognizer) {
        if tap.state == .ended {
            guard let collcetionV = self.superview as? UICollectionView,
                  let index = collcetionV.indexPath(for: self) else { return }
            delegate?.dismissVc(by: index, imageV: imageV)
        }
    }
    
    func doubleAction(tap: UITapGestureRecognizer) {
        if tap.state == .ended {
            if backScollView.zoomScale == 1 {
                backScollView.setZoomScale(2, animated: true)
            } else {
                backScollView.setZoomScale(1, animated: true)
            }
        }
    }
    
    func panAction(pan: UIPanGestureRecognizer) {
        if pan.state == .began {
            
        } else if pan.state == .changed {
//            if pan. {
//                <#code#>
//            }
        }
    }
}


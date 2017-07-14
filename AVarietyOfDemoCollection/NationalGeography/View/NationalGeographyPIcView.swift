//
//  NationalGeographyPicView.swift
//  AVarietyOfDemoCollection
//
//  Created by Apple on 2017/7/14.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit
import SDWebImage

class NationalGeographyPicView: UIView {

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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var model: NationalGeographyPicModel! {
        didSet {
            guard let url = URL.init(string: model.url) else { return }
            configImageV(url: url)
        }
    }
    
    fileprivate func configImageV(url: URL) {
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

extension NationalGeographyPicView: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageV
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        view?.center = CGPoint(x: screen_s.width / 2, y: screen_s.height / 2)
    }
    
    
}

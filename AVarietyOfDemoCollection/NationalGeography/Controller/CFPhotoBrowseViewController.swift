//
//  CFPhotoBrowseViewController.swift
//  AVarietyOfDemoCollection
//
//  Created by 曹飞 on 2017/7/15.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit
import Photos

protocol CFPhotoBrowseViewControllerDelegate: NSObjectProtocol {
    func panGestureForVcDismissBegin(idx: Int, isDismiss: Bool)
}

class CFPhotoBrowseViewController: UIViewController {
    
    fileprivate lazy var scollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.frame = CGRect(x: 0, y: 0, width: screen_s.width + 20, height: screen_s.height)
        scroll.backgroundColor = UIColor.black
        scroll.isPagingEnabled = true
        scroll.contentSize = CGSize(width: (screen_s.width + 20) * CGFloat(self.imgUrls.count), height: screen_s.height)
        scroll.delegate = self
        return scroll
    }()
    
    fileprivate lazy var panGesture: UIPanGestureRecognizer = {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panAction))
        return pan
    }()
    
    fileprivate lazy var longGestue: UILongPressGestureRecognizer = {
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longAction))
        longGesture.minimumPressDuration = 1
        return longGesture
    }()
    
    public weak var delegate: CFPhotoBrowseViewControllerDelegate?
    
    fileprivate var cfPhotoBrowsePictureViews: [CFPhotoBrowsePictureView] = []
    fileprivate var currentImgVLastSupperV: UIView?
    public var imgUrls: [String] = []
    fileprivate var thumbnails: [UIImage?] = []
    public var currentImageV: UIImageView?
    public var currentIdx: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeInterface()
        // Do any additional setup after loading the view.
    }
    
    convenience init(imgUrls: [String], thumbnails: [UIImage?], selectedIdx: Int?) {
        self.init(nibName: nil, bundle: nil)
        self.imgUrls = imgUrls
        self.thumbnails = thumbnails
        if let idx = selectedIdx {
            self.currentIdx = idx
        }
    }
    
    fileprivate func initializeInterface() {
        view.addSubview(scollView)
        view.addGestureRecognizer(panGesture)
        view.addGestureRecognizer(longGestue)
        addSubViews()
        registPhotoLibrary()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension CFPhotoBrowseViewController {
    
    fileprivate func addSubViews() {
        for (idx, imgUrl) in imgUrls.enumerated() {
            let subView: CFPhotoBrowsePictureView = CFPhotoBrowsePictureView(frame: CGRect(x: (screen_s.width + 20) * CGFloat(idx), y: 0, width: screen_s.width, height: screen_s.height), imgUrl: imgUrl, thumbnail: thumbnails[idx], idx: currentIdx)
            subView.delegate = self
            scollView.addSubview(subView)
            if idx == currentIdx {
                currentImageV = subView.imageV
                subView.loadingImage()
            }
            cfPhotoBrowsePictureViews.append(subView)
        }
        scollView.setContentOffset(CGPoint(x: CGFloat(currentIdx) * scollView.frame.width, y: 0), animated: false)
    }
}

extension CFPhotoBrowseViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        currentIdx = Int(scrollView.contentOffset.x / ((screen_s.width + 20)))
        currentImageV = cfPhotoBrowsePictureViews[currentIdx].imageV
        cfPhotoBrowsePictureViews[currentIdx].loadingImage()
    }
}

extension CFPhotoBrowseViewController: CFPhotoBrowsePictureViewDelegate {
    
    func dismissVc(by idx: Int, imageV: UIImageView) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension CFPhotoBrowseViewController {
    
    func longAction(long: UILongPressGestureRecognizer) {
        if long.state == .began {
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
            let saveAction = UIAlertAction(title: "保存图片", style: UIAlertActionStyle.default, handler: { (action) in
                self.saveImage(image: self.currentImageV?.image)
            })
            let cancel = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(saveAction)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func panAction(pan: UIPanGestureRecognizer) {
        let translationPt = pan.translation(in: pan.view)
        if translationPt.y < 0 {
            return
        }
        var percent = translationPt.y / screen_s.height
        if percent > 1 {
            percent = 1
        }
        if pan.state == .began {
            guard let imgV = currentImageV else { return }
            currentImgVLastSupperV = imgV.superview
            imgV.removeFromSuperview()
            view.window?.addSubview(imgV)
            delegate?.panGestureForVcDismissBegin(idx: currentIdx, isDismiss: false)
        } else if pan.state == .changed {
            currentImageV?.transform = CGAffineTransform.init(translationX: translationPt.x, y: translationPt.y).scaledBy(x: 1 - percent, y: 1 - percent)
            view.alpha = 1 - percent
        } else if pan.state == .ended {
            if percent > 0.3 {
                self.dismiss(animated: true, completion: { 
                    self.delegate?.panGestureForVcDismissBegin(idx: self.currentIdx, isDismiss: true)
                })
            } else {
                guard let lastSupperV = currentImgVLastSupperV, let imgV = currentImageV else { return }
                imgV.removeFromSuperview()
                lastSupperV.addSubview(imgV)
                UIView.animate(withDuration: 0.3, animations: {
                    self.currentImageV?.transform = CGAffineTransform.identity
                    self.view.alpha = 1
                })
                delegate?.panGestureForVcDismissBegin(idx: currentIdx, isDismiss: false)
            }
        }
    }
}

extension CFPhotoBrowseViewController {
    
    fileprivate func registPhotoLibrary() {
        if PHPhotoLibrary.authorizationStatus() == .notDetermined {
            PHPhotoLibrary.requestAuthorization({ (status) in
                
            })
        }
    }
    
    fileprivate func saveImage(image: UIImage?) {
        guard let img = image else { return }
        PHPhotoLibrary.shared().performChanges({ 
            PHAssetChangeRequest.creationRequestForAsset(from: img)
        }) { (success, error) in
            if !success {
                print(error?.localizedDescription ?? "error")
            }
        }
        
    }
}

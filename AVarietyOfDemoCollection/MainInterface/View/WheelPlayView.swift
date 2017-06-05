//
//  WheelPlayView.swift
//  multipleFrameworkDemo
//
//  Created by Apple on 2017/1/13.
//  Copyright © 2017年 cf. All rights reserved.
//

import UIKit

class WheelPlayView: UIView,UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate {
    
    lazy var collectionV: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = self.bounds.size
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        flowLayout.sectionInset = UIEdgeInsets.zero
        flowLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
        let view:UICollectionView = UICollectionView(frame: self.bounds, collectionViewLayout: flowLayout)
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.isPagingEnabled = true
        view.register(WheelPlayCollectionViewCell.self, forCellWithReuseIdentifier: "WheelPlayCell")
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    lazy var pageControl: UIPageControl = {
        let page: UIPageControl = UIPageControl(frame: CGRect(x: 0, y: self.bounds.height - 22, width: self.bounds.width, height: 22))
       return page
    }()
    
    var dataArray = [String](){
        didSet{
            if dataArray.count > 0 {
                dataArray.insert(dataArray.last!, at: 0)
                dataArray.append(dataArray[1])
                pageControl.numberOfPages = dataArray.count - 2
                collectionV.reloadData()
                collectionV.scrollToItem(at: IndexPath.init(item: 1, section: 0), at: UICollectionViewScrollPosition.centeredHorizontally, animated: false)
            }
        }
    }
    
    var timer:Timer?
    
    func addTimer() {
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(scrollImgView), userInfo: nil, repeats: true)
    }
    
    func removeTimer() {
        guard let time = timer else { return }
        if time.isValid {
            time.invalidate()
        }
        timer = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(collectionV)
        self.addSubview(pageControl)
    }
    
    deinit {
        removeTimer()
    }
    
    func scrollImgView() {
        guard let index = collectionV.indexPathsForVisibleItems.last else { return }
        let targetIndex = IndexPath.init(item: index.row + 1, section: 0)
        collectionV.scrollToItem(at: targetIndex, at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
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

extension WheelPlayView {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WheelPlayCell", for: indexPath) as?   WheelPlayCollectionViewCell else { fatalError("notfoundcell") }
        cell.imgName = dataArray[indexPath.row]
        return cell
    }
}

extension WheelPlayView {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == collectionV && scrollView.isDragging {
            if scrollView.contentOffset.x >= CGFloat(dataArray.count - 1) * self.bounds.width {
                collectionV.scrollToItem(at: IndexPath.init(row: 1, section: 0), at: .centeredHorizontally, animated: false)
            }else if (scrollView.contentOffset.x <= 0) {
                collectionV.scrollToItem(at: IndexPath.init(row: dataArray.count - 2, section: 0), at: .centeredHorizontally, animated: false)
            }
        }
        let num = (scrollView.contentOffset.x / self.bounds.width) - 0.5
        pageControl.currentPage = Int(num)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if scrollView == collectionV {
            if scrollView.contentOffset.x >= (CGFloat(dataArray.count) - 1.5) * self.bounds.width {
                collectionV.scrollToItem(at: IndexPath.init(row: 1, section: 0), at: .centeredHorizontally, animated: false)
            }
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == collectionV {
            timer?.fireDate = Date.distantFuture
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == collectionV {
            timer?.fireDate = Date.init(timeIntervalSinceNow: 5)
        }
    }
}

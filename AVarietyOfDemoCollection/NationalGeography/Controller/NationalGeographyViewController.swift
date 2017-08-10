//
//  NationalGeographyViewController.swift
//  AVarietyOfDemoCollection
//
//  Created by Apple on 2017/6/13.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit
import ReactiveCocoa
import SDWebImage

class NationalGeographyViewController: UIViewController {
    
    fileprivate let viewModel = NationalGeographyViewModel()
    public var currentImgV: UIImageView!
    public var currentCollectionView: UICollectionView!
    @IBOutlet weak var listTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeInterface()
        // Do any additional setup after loading the view.
    }
    
    func initializeInterface() {
        title = "NationalGeography"
        listTableView.addRefreshHeaderAndFooter(headerClosure: { [weak self] in
            self?.viewModel.isPulldown = true
            self?.viewModel.getLists()
        }) { [weak self] in
            self?.viewModel.isPulldown = false
            self?.viewModel.getLists()
        }
        listTableView.tableFooterView = UIView()
        bindingViewModel()
        listTableView.mj_header.beginRefreshing()
    }
    
    deinit {
        print("NationalGeographyViewController deinit")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension NationalGeographyViewController {
    
    func bindingViewModel() {
        viewModel.reactive.signal(forKeyPath: "pulldownRefreshMsg").observeValues { [weak self] (msg) in
            self?.listTableView.reloadDataByRefresh(by: msg, pulldownSuccess: nil, fail: {
                print("fail")
            })
        }
    }
}

extension NationalGeographyViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.nationalModelList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NationalGeographyTableViewCell = tableView.dequeueReusableCell(withIdentifier: "NationalGeographyTableViewCell", for: indexPath) as! NationalGeographyTableViewCell
        cell.albumModel = viewModel.nationalModelList[indexPath.row]
        cell.delegate = self
        return cell
    }
}

extension NationalGeographyViewController: NationalGeographyTableViewCellDelegate {
    
    func didSelectCell(with imageV: UIImageView, collectionView: UICollectionView, albumModel: NationalGeographyAlbumModel, indexPath: IndexPath) {
        currentImgV = imageV
        currentCollectionView = collectionView
        let urls = albumModel.picModel.map({ $0.url })
        var imgs = [UIImage?]()
        for idx in 0 ..< urls.count {
            guard let cell = collectionView.cellForItem(at: IndexPath(item: idx, section: 0)) as? NationalGeographyCollectionViewCell else { return }
            imgs.append(cell.imageV.image)
        }
        let vc = CFPhotoBrowseViewController(imgUrls: urls, thumbnails: imgs, selectedIdx: indexPath.row)
        vc.transitioningDelegate = self
        vc.modalPresentationStyle = .custom
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
}

extension NationalGeographyViewController: CFPhotoBrowseViewControllerDelegate {
    
    func panGestureForVcDismissBegin(idx: Int, isDismiss: Bool) {
        guard let cell = currentCollectionView.cellForItem(at: IndexPath(item: idx, section: 0)) as? NationalGeographyCollectionViewCell else { return }
        cell.imageV.isHidden = !isDismiss
    }
}

extension NationalGeographyViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CFPhotoBrowseTransitionAnimation(transitionstyle: CFPhotoBrowseTransitionAnimationStyle.present)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CFPhotoBrowseTransitionAnimation(transitionstyle: CFPhotoBrowseTransitionAnimationStyle.dismiss)
    }
}

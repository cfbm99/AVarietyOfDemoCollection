//
//  CustomVideoPlayerViewController.swift
//  multipleFrameworkDemo
//
//  Created by Apple on 2017/4/21.
//  Copyright © 2017年 cf. All rights reserved.
//

import UIKit

class CustomVideoPlayerViewController: UIViewController {

    @IBOutlet weak var vedioTableView: UITableView!
    fileprivate let viewModel = CustomVideoPlayerViewModel()
    
    fileprivate lazy var avPlayerView: CustomVideoPlayerView = {
        let view = Bundle.main.loadNibNamed("CustomVideoPlayerView", owner: nil, options: nil)?.first as! CustomVideoPlayerView
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeInterface()
        // Do any additional setup after loading the view.
    }
    
    func initializeInterface() {
        title = "视频"
        vedioTableView.estimatedRowHeight = 80;
        vedioTableView.rowHeight = UITableViewAutomaticDimension
        vedioTableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10)

        vedioTableView.cf_footer = CFRefreshNormalFooter(refreshClosure: { [weak self] in
            self?.viewModel.isPulldown = false
            self?.viewModel.requestVideos()
        })
        vedioTableView.mj_header = CFArrowRefreshHeader(refreshingBlock: { [weak self] in
            self?.viewModel.isPulldown = true
            self?.viewModel.requestVideos()
            if let _ = self?.avPlayerView.superview {
                self?.avPlayerView.removeFromSuperview()
                LoadingViewManager.manager.hideLoadingView()
            }
            self?.avPlayerView.removeObserver()
        })
        Addkvo()
        viewModel.requestVideos()
    }
    
    func Addkvo() {
        viewModel.addObserver(self, forKeyPath: "pulldownRefreshMsg", options: .new, context: nil)
        viewModel.addObserver(self, forKeyPath: "requestMsg", options: .new, context: nil)
    }
    
    deinit {
        viewModel.removeObserver(self, forKeyPath: "pulldownRefreshMsg")
        viewModel.removeObserver(self, forKeyPath: "requestMsg")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "pulldownRefreshMsg" {
            vedioTableView.reloadRefreshData(change: change, pulldownSuccess: nil)
        } else if keyPath == "requestMsg" {
            if viewModel.requestMsg == .success {
                avPlayerView.url = viewModel.videoUrlModel.url
            } else {
                print("fail")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension CustomVideoPlayerViewController: UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.vedioModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomVideoPlayerTableViewCell", for: indexPath) as? CustomVideoPlayerTableViewCell else { fatalError("no vedioModels") }
        cell.model = viewModel.vedioModels[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let url = viewModel.vedioModels[indexPath.row].full_url,let cell = tableView.cellForRow(at: indexPath) as? CustomVideoPlayerTableViewCell else { return }
        viewModel.requestForVideoUrl(url: url)
        addCustomPlayerView(cell: cell)
    }
    
    func addCustomPlayerView(cell:CustomVideoPlayerTableViewCell) {
        if let _ = avPlayerView.superview {
            avPlayerView.removeFromSuperview()
            LoadingViewManager.manager.hideLoadingView()
        }
        avPlayerView.frame = cell.convert(cell.imageV.frame, to: vedioTableView)
        avPlayerView.removeObserver()
        vedioTableView.addSubview(avPlayerView)
        LoadingViewManager.manager.showLoadingView(color: #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), toView: avPlayerView)
    }
    
}

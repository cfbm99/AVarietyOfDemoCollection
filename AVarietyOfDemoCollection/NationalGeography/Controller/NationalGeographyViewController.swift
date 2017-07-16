//
//  NationalGeographyViewController.swift
//  AVarietyOfDemoCollection
//
//  Created by Apple on 2017/6/13.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit
import ReactiveCocoa

class NationalGeographyViewController: UIViewController {
    
    let viewModel = NationalGeographyViewModel()
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
    
    func didSelectCell(cell: NationalGeographyCollectionViewCell, albumModel: NationalGeographyAlbumModel, indexPath: IndexPath) {
        let vc = CFPhotoBrowseViewController()
        vc.imgUrls = albumModel.picModel.map({ $0.url })
        self.present(vc, animated: true, completion: nil)
    }
}

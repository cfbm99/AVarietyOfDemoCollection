//
//  HeadlineNewsViewController.swift
//  AVarietyOfDemoCollection
//
//  Created by Apple on 2017/5/24.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit

class HeadlineNewsViewController: NewsBaseViewController {
    
    let viewModel = HeadlineNewsViewModel()
    
    lazy var wheelView: WheelPlayView = {
        let view: WheelPlayView = WheelPlayView(frame: CGRect(x: 0, y: 0, width: screen_s.width, height: screen_s.width / 2))
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subclassInitializeInterface()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        wheelView.addTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        wheelView.removeTimer()
    }
    
    func subclassInitializeInterface() {
        tableV.tableHeaderView = wheelView
        tableV.estimatedSectionHeaderHeight = 80
        tableV.register(HeadlineNesHeaderView.self, forHeaderFooterViewReuseIdentifier: "HeadlineNesHeaderView")
        tableV.delegate = self
        tableV.dataSource = self
        addKvo()
        
        if  traitCollection.forceTouchCapability == .available, #available(iOS 9.0, *) {
            self.registerForPreviewing(with: self, sourceView: tableV)
        }
        
        tableV.cf_header = CFRefreshNormalHeader(refreshClosure: { [weak self] in
            self?.viewModel.isPulldown = true
            self?.viewModel.getHeadlineNews()
        })
        tableV.cf_footer = CFRefreshNormalFooter(refreshClosure: { [weak self] in
            self?.viewModel.isPulldown = false
            self?.viewModel.getHeadlineNews()
        })
        tableV.cf_header?.beginRefresh()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        viewModel.removeObserver(self, forKeyPath: #keyPath(HeadlineNewsViewModel.pulldownRefreshMsg))
    }
    
}

extension HeadlineNewsViewController {
    
    fileprivate func addKvo() {
        viewModel.addObserver(self, forKeyPath: #keyPath(HeadlineNewsViewModel.pulldownRefreshMsg), options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath ==  #keyPath(HeadlineNewsViewModel.pulldownRefreshMsg){
            tableV.reloadRefreshData(change: change, pulldownSuccess: {[weak self] in
                if let models = self?.viewModel.picModels {
                    self?.wheelView.dataArray = models.map{ $0.imgsrc }
                }
            })
        }
    }
}

extension HeadlineNewsViewController: UIViewControllerPreviewingDelegate {
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = tableV.indexPathForRow(at: location) else { return nil }
        let selectCellFrame = tableV.cellForRow(at: indexPath)!.frame
        let vc: NewsBaseDetailViewController = NewsBaseDetailViewController()
        vc.id = viewModel.listModels[indexPath.row].id
        previewingContext.sourceRect = selectCellFrame
        return vc
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        
    }
}

extension HeadlineNewsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionCountArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionName = viewModel.sectionCountArray[section]
        if sectionName == "tuijian" {
            return viewModel.tuijianLists.count
        }
        return viewModel.listModels.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 10
        }
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionName = viewModel.sectionCountArray[section]
        if sectionName == "tuijian" {
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HeadlineNesHeaderView")
            return header
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionName = viewModel.sectionCountArray[indexPath.section]
        if sectionName == "tuijian" {
            let cell: NewsBaseTableViewCell = tableView.dequeueReusableCell(withIdentifier: "NewsBaseTableViewCell", for: indexPath) as! NewsBaseTableViewCell
            cell.tuijianModel = viewModel.tuijianLists[indexPath.row]
            return cell
        }
        
        let model = viewModel.listModels[indexPath.row]
        if model.listStyle == "2" {
            let cell: NewsBaseStyle2TableViewCell = tableView.dequeueReusableCell(withIdentifier: "NewsBaseStyle2TableViewCell", for: indexPath) as! NewsBaseStyle2TableViewCell
            cell.model = model
            return cell
        } else if model.listStyle == "3" {
            let cell: NewsBaseStyle3TableViewCell = tableView.dequeueReusableCell(withIdentifier: "NewsBaseStyle3TableViewCell", for: indexPath) as! NewsBaseStyle3TableViewCell
            cell.model = model
            return cell
        } else {
            guard let cell: NewsBaseTableViewCell = tableView.dequeueReusableCell(withIdentifier: "NewsBaseTableViewCell", for: indexPath) as? NewsBaseTableViewCell else { fatalError("no cell") }
            cell.model = model
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc: NewsBaseDetailViewController = NewsBaseDetailViewController()
        let sectionName = viewModel.sectionCountArray[indexPath.section]
        if sectionName == "tuijian" {
            vc.id = viewModel.tuijianLists[indexPath.row].id
        } else {
            vc.id = viewModel.listModels[indexPath.row].id
        }
        navigationController?.navigationItem.backBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
}

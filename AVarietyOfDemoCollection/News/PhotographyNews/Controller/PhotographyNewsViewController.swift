//
//  PhotographyNewsViewController.swift
//  AVarietyOfDemoCollection
//
//  Created by Apple on 2017/6/9.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit

class PhotographyNewsViewController: NewsBaseViewController {
    
    let viewModel = PhotographyNewsViewModel()
    
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
        tableV.delegate = self
        tableV.dataSource = self
        addKvo()
        tableV.mj_header = CFArrowRefreshHeader(refreshingBlock: { [weak self] in
            self?.viewModel.isPulldown = true
            self?.viewModel.getList()
        })
        tableV.cf_footer = CFRefreshNormalFooter(refreshClosure: { [weak self] in
            self?.viewModel.isPulldown = false
            self?.viewModel.getList()
        })
        tableV.mj_header?.beginRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        if self.isViewLoaded {
            viewModel.removeObserver(self, forKeyPath: #keyPath(PhotographyNewsViewModel.pulldownRefreshMsg))
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PhotographyNewsViewController {
    
    fileprivate func addKvo() {
        viewModel.addObserver(self, forKeyPath: #keyPath(PhotographyNewsViewModel.pulldownRefreshMsg), options: .new, context: nil)
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

extension PhotographyNewsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.listModels.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = viewModel.listModels[indexPath.row]
        if model.type == "18" {
            let cell: NewsBaseStyle2TableViewCell = tableView.dequeueReusableCell(withIdentifier: "NewsBaseStyle2TableViewCell", for: indexPath) as! NewsBaseStyle2TableViewCell
            cell.model = model
            return cell
        } else if model.type == "6" {
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
        vc.id = viewModel.listModels[indexPath.row].id
        navigationController?.pushViewController(vc, animated: true)
    }
}


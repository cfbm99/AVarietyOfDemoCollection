//
//  NewsMainInterfaceViewController.swift
//  AVarietyOfDemoCollection
//
//  Created by Apple on 2017/5/23.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit

class NewsMainInterfaceViewController: UIViewController {
    
    lazy var mainScrollView: UIScrollView = {
        let view: UIScrollView = UIScrollView(frame: CGRect(x: 0, y: 108, width: screen_s.width, height: screen_s.height - 108))
        view.isPagingEnabled = true
        view.alwaysBounceHorizontal = true
        view.delegate = self
        return view
    }()
    
    lazy var titleLb: UILabel = {
        let label: UILabel = UILabel()
        label.text = "中关村在线"
        label.textColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        label.font = UIFont.init(name: "Verdana-Bold", size: 17)
        label.sizeToFit()
        return label
    }()
    
    lazy var backBtn: UIButton = {
        let btn: UIButton = UIButton(type: UIButtonType.custom)
        btn.setTitle("返回", for: .normal)
        btn.titleLabel?.font = UIFont.init(name: "Verdana-Bold", size: 17)
        btn.setTitleColor(#colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), for: .normal)
        btn.addTarget(self, action: #selector(popVc), for: .touchUpInside)
        return btn
    }()
    
    var navIsHide = false
    
    var titlesArray = ["头条","摄影","hello","hello","hello","hello","hello","hello","hello","hello","hello","hello"]
    var subVcs = [NewsBaseViewController]()
    
    let titlesView: NewsTitlesView = NewsTitlesView(frame: CGRect(x: 0, y: 64, width: screen_s.width, height: 44))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeInterface()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @objc fileprivate func popVc() {
        navigationController?.popViewController(animated: true)
    }
    
    func initializeInterface() {
        self.automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = UIColor.white
        view.addSubview(titleLb)
        view.addSubview(backBtn)
        view.addSubview(titlesView)
        view.addSubview(mainScrollView)
        
        titleLb.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(30)
        }
        
        backBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(titleLb)
            make.left.equalToSuperview().offset(10)
        }
     
        self.refreshTitles()
        self.configSubVcs()
        
    }
    
    fileprivate func refreshTitles() {
        titlesView.titlesArray = titlesArray
    }
    
    fileprivate func configSubVcs() {
        for title in titlesArray {
            if title == "头条" {
                subVcs.append(HeadlineNewsViewController())
            } else if title == "摄影" {
                subVcs.append(PhotographyNewsViewController())
            } else {
                subVcs.append(NewsBaseViewController())
            }
        }
        mainScrollView.contentSize = CGSize(width: CGFloat(subVcs.count) * screen_s.width, height: 0)
        print("add vc finish")
        scrollViewDidEndDecelerating(mainScrollView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension NewsMainInterfaceViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / screen_s.width)
        addSubVc(index: index)
    }
    
    func addSubVc(index: Int) {
        let vc = subVcs[index]
        if vc.isViewLoaded {
            return
        }
        self.addChildViewController(vc)
        vc.view.frame = CGRect(x: screen_s.width * CGFloat(index), y: 0, width: screen_s.width, height: mainScrollView.bounds.height)
        vc.view.autoresizingMask = .flexibleHeight
        vc.delegate = self
        mainScrollView.addSubview(vc.view)
        vc.didMove(toParentViewController: self)
    }
    
}

extension NewsMainInterfaceViewController: NewsBaseViewControllerDelegate {
    
    func tableViewDidScroll(offsetY: CGFloat) {
   //     print(offsetY)
        if !navIsHide && offsetY < 0 {
            UIView.animate(withDuration: 0.3, animations: { 
                self.navigationController?.navigationBar.transform = CGAffineTransform.init(translationX: 0, y: -64)
                self.mainScrollView.frame = CGRect(x: 0, y: 64, width: screen_s.width, height: screen_s.height - 64)
                self.titlesView.transform = CGAffineTransform.init(translationX: 0, y: -44)
                self.titleLb.transform = CGAffineTransform.init(translationX: 0, y: -54)
            }, completion: { (finish) in
                self.navIsHide = true
            })
        }else if navIsHide && offsetY > 0 {
            UIView.animate(withDuration: 0.3, animations: {
                self.navigationController?.navigationBar.transform = CGAffineTransform.identity
                self.mainScrollView.frame = CGRect(x: 0, y: 108, width: screen_s.width, height: screen_s.height - 108)
                self.titlesView.transform = CGAffineTransform.identity
                self.titleLb.transform = CGAffineTransform.identity
            }, completion: { (finish) in
                self.navIsHide = false
            })
        }
    }
}

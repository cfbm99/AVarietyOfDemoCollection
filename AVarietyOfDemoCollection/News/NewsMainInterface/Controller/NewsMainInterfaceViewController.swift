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
    
    var navIsHide = false
    
    var titlesArray = ["头条","hello","hello","hello","hello","hello","hello","hello","hello","hello","hello","hello"]
    var subVcs = [NewsBaseViewController]()
    
    let titlesView: NewsTitlesView = NewsTitlesView(frame: CGRect(x: 0, y: 64, width: screen_s.width, height: 44))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeInterface()
        // Do any additional setup after loading the view.
    }
    
    func initializeInterface() {
        self.automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = UIColor.white
        view.addSubview(titlesView)
        view.addSubview(mainScrollView)
     
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
            }else {
                subVcs.append(NewsBaseViewController()) 
            }
        }
        mainScrollView.contentSize = CGSize(width: CGFloat(subVcs.count) * screen_s.width, height: 0)
        print("add vc finish")
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
        vc.view.frame = CGRect(x: screen_s.width * CGFloat(index), y: 0, width: screen_s.width, height: screen_s.height - 108)
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
            }, completion: { (finish) in
                self.navIsHide = true
            })
        }else if navIsHide && offsetY > 0 {
            UIView.animate(withDuration: 0.3, animations: {
                self.navigationController?.navigationBar.transform = CGAffineTransform.identity
                self.mainScrollView.frame = CGRect(x: 0, y: 108, width: screen_s.width, height: screen_s.height - 108)
                self.titlesView.transform = CGAffineTransform.identity
            }, completion: { (finish) in
                self.navIsHide = false
            })
        }
    }
}

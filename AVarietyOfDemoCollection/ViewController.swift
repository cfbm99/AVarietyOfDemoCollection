//
//  ViewController.swift
//  AVarietyOfDemoCollection
//
//  Created by Apple on 2017/5/17.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let viewModel = MainInterfaceViewModel()
    
    @IBOutlet weak var mainCollectionV: UICollectionView!
    @IBOutlet weak var mainFlowLayout: UICollectionViewFlowLayout!
    
    var headerViewHeight: CGFloat {
        return screen_s.width * 0.5
    }
    
    let menus: [[String: String]] = [["title":"News","image":"news"],["title":"QRCodeCreatAndScan","image":"video"],["title":"CustomVideoPlayer","image":"video"],["title":"CubeRotation","image":"video"],["title":"NationalGeography","image":"video"],["title":"UIDynamic","image":"news"],["title":"hello","image":"video"],["title":"hello","image":"news"],["title":"hellohello","image":"news"],["title":"hellohellohello","image":"news"],["title":"hello","image":"video"]]
    
    lazy var wheelView: WheelPlayView = {
        let view: WheelPlayView = WheelPlayView(frame: CGRect(x: 0, y: -self.headerViewHeight, width: screen_s.width, height: self.headerViewHeight))
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initializeInterface()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        wheelView.addTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        wheelView.removeTimer()
    }
    
    func initializeInterface() {
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        //mainFlowLayout.itemSize = CGSize(width: screen_s.width / 4, height: screen_s.width / 4)
        mainFlowLayout.estimatedItemSize = CGSize(width: 100, height: 100)
        mainFlowLayout.sectionInset = UIEdgeInsets.zero
        mainFlowLayout.minimumLineSpacing = 0
        mainFlowLayout.minimumInteritemSpacing = 0
        mainCollectionV.contentInset = UIEdgeInsetsMake(headerViewHeight, 0, 0, 0)
        mainCollectionV.insertSubview(wheelView, at: 0)
        addKvo()
        viewModel.getMainInterfaceHeaderViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        viewModel.removeObserver(self, forKeyPath: "requestMsg")
        mainCollectionV.removeObserver(self, forKeyPath: "contentOffset")
    }

}

extension ViewController {
    
    fileprivate func addKvo() {
        viewModel.addObserver(self, forKeyPath: #keyPath(MainInterfaceViewModel.requestMsg), options: .new, context: nil)
        mainCollectionV.addObserver(self, forKeyPath: #keyPath(UICollectionView.contentOffset), options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "requestMsg" {
            if let msgValue = change?[.newKey] as? NSNumber,
                let msg = RequestMsg(rawValue: msgValue.intValue) {
                switch msg {
                case .success:
                    guard let models = viewModel.headerViewsModels else { return }
                    wheelView.dataArray = models.map{ $0.thumb }
                case .noData:
                    print("no data")
                case .fail:
                    print("fail")
                }
            }
        }else if keyPath == "contentOffset" {
            if let value = change?[.newKey] as? NSValue {
                let offsetY = value.cgPointValue.y + headerViewHeight
                if offsetY > 0 {
                    return
                } else {
                    wheelView.transform = CGAffineTransform.init(scaleX: 1 + (-offsetY / 64), y: 1 + (-offsetY / 64))
                }
            }
        }
    }

}

extension ViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menus.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: MainInterfaceCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainInterfaceCollectionViewCell", for: indexPath) as? MainInterfaceCollectionViewCell else { fatalError("no MainInterfaceCollectionViewCell") }
        cell.titleLb.text = menus[indexPath.row]["title"]
        cell.imageV.image = UIImage.init(named: menus[indexPath.row]["image"]!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let title = menus[indexPath.row]["title"] else { return }
        if title == "News" {
            self.navigationController?.pushViewController(NewsMainInterfaceViewController(), animated: true)
        } else if title == "QRCodeCreatAndScan" {
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "QRCodeCreatViewController")
            navigationController?.pushViewController(vc, animated: true)
        } else if title == "CustomVideoPlayer" {
            performSegue(withIdentifier: "CustomVideoPlayerViewController", sender: nil)
        } else if title == "CubeRotation" {
            navigationController?.pushViewController(CubeRotationViewController(), animated: true)
        } else if title == "NationalGeography" {
            self.performSegue(withIdentifier: "NationalGeographyViewController", sender: nil)
        } else if title == "UIDynamic" {
            navigationController?.pushViewController(UIDynamicViewController(), animated: true)
        }
    }
    
}


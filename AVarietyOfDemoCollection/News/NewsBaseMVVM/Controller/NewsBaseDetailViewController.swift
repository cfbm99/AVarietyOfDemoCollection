//
//  NewsBaseDetailViewController.swift
//  AVarietyOfDemoCollection
//
//  Created by Apple on 2017/6/5.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit
import WebKit

class NewsBaseDetailViewController: UIViewController {
    
    fileprivate lazy var webView: WKWebView = {
        let web: WKWebView = WKWebView(frame: self.view.bounds)
        web.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        web.navigationDelegate = self
        return web
    }()
    
    fileprivate lazy var progress: UIProgressView = {
        let progress: UIProgressView = UIProgressView(frame: CGRect(x: 0, y: 0, width: screen_s.width, height: 2))
        progress.setProgress(0.1, animated: true)
        progress.tintColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        progress.trackTintColor = UIColor.clear
        return progress
    }()
    
    lazy var getImages: String = {
        var jsGetImages = "function getImages(){";
        jsGetImages += "var objs = document.getElementsByTagName(\"img\");";
        jsGetImages += "var imgScr = '';";
        jsGetImages += "for (var i = 0; i < objs.length; ++i){";
        jsGetImages += "imgScr = imgScr + objs[i].src + '+';";
        jsGetImages += "};";
        jsGetImages += "return imgScr;";
        jsGetImages += "};";
        return jsGetImages
    }()
    
    
    public var id: String!
    
    fileprivate var url: String! {
        didSet {
            guard let url = URL.init(string: url) else { return }
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    deinit {
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeInterface()
        // Do any additional setup after loading the view.
    }
    
    func initializeInterface() {
        self.navigationController?.navigationBar.addSubview(progress)
        view.addSubview(webView)
        let strUrl = String.init(format: detailUrl, id)
        url = strUrl
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            guard let value = change?[.newKey] as? NSNumber else { return }
            progress.setProgress(value.floatValue, animated: true)
            if value.floatValue == 1 {
                UIView.animate(withDuration: 0.3, animations: { 
                    self.progress.alpha = 0
                }, completion: { (finish) in
                    self.progress.setProgress(0, animated: false)
                })
            }
        }
    }
    
    func jsInteraction(js: String) {
        webView.evaluateJavaScript(js) { (result, error) in
            
        }
    }
    
    func getImgs() {
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension NewsBaseDetailViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        //获取高度
        webView.evaluateJavaScript("document.body.offsetHeight") { (result, error) in
            if error == nil {
                guard let height = result as? NSNumber else { return }
                print(height.floatValue)
            }
        }
        //获取全部图片
        webView.evaluateJavaScript(getImages, completionHandler: nil)
        webView.evaluateJavaScript("getImages()") { (result, error) in
            if error == nil {
                guard let imageStr = result as? String else { return }
                let images = imageStr.components(separatedBy: "+").filter({ (url) -> Bool in
                    return url.hasPrefix("http://uppic")
                })
                print(images)
            }
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        decisionHandler(.allow)
    }
}

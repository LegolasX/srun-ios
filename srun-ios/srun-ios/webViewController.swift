//
//  webViewController.swift
//  srun-ios
//
//  Created by Legolas Invoker on 2017/8/24.
//  Copyright © 2017年 Legolas Invoker. All rights reserved.
//

import UIKit
import WebKit
class webViewController: UIViewController, WKUIDelegate, UIScrollViewDelegate, WKNavigationDelegate{
    lazy var webView : WKWebView = {
        let web = WKWebView()
        web.navigationDelegate = self
        web.uiDelegate = self
        web.scrollView.delegate = self
        return web
    }()
    var userName : String?
    var password : String?
    var timer : Timer?
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(webView)
        
        view.bringSubview(toFront: indicator)
        let request = URLRequest(url:URL(string:"http://self.ncepu.edu.cn:8800")!)
        webView.scrollView.addObserver(self, forKeyPath: #keyPath(UIScrollView.contentSize), options: (NSKeyValueObservingOptions.new), context: nil)
        webView.load(request)
        timer = Timer(timeInterval: 10, target: self, selector: #selector(webViewController.fireTimer), userInfo: nil, repeats: false)
        RunLoop.current.add(timer!, forMode: RunLoopMode.commonModes)
    }
    
    override func viewWillLayoutSubviews() {
        webView.translatesAutoresizingMaskIntoConstraints = false
        super.viewWillLayoutSubviews()
        // align webView from the left and right
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": webView]))
        
        // align webView from the top and bottom
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": webView]))
    }

    @objc func fireTimer() {
        let alert = UIAlertController(title: "校园网可能崩了", message: "连不上校园网，看看WiFi对么", preferredStyle: .alert)
        let action = UIAlertAction(title: "返回", style: .cancel) { _ in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print(error)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        timer?.invalidate()
        indicator.stopAnimating()
    }
    
    //Alert弹框
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: message, message: nil, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "好的", style: UIAlertActionStyle.cancel) { (_) in
            completionHandler()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    //confirm弹框
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: message, message: nil, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "确定", style: UIAlertActionStyle.default) { (_) in
            completionHandler(true)
        }
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel) { (_) in
            completionHandler(false)
        }
        alert.addAction(action)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fillInBlack() {
        if let password = self.password, let userName = self.userName {
        webView.evaluateJavaScript("document.getElementById('password').value = '\(password)',document.getElementById('username').value = '\(userName)'", completionHandler: { (obj, error) in
            if let error = error {
                print("js error: \(error)")
            }
        })
        }
    }

    var hasRemoveKVO = false
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let change = change else { return }
//        guard let keyPath = keyPath else { return }
        guard let newSize = change[NSKeyValueChangeKey.newKey] as? CGSize else { return }
        if webView.scrollView.zoomScale == 1.28228787897595 {
            webView.scrollView.removeObserver(self, forKeyPath: #keyPath(UIScrollView.contentSize))
            hasRemoveKVO = true
            self.webView.scrollView.setContentOffset(CGPoint.init(x: 814, y: 135), animated: true)
            fillInBlack()
        }
        guard newSize.width == UIScreen.main.bounds.width && webView.isLoading == false else { return }
        if webView.scrollView.zoomScale != 1 {
            webView.scrollView.setZoomScale(1.28228787897595, animated: true)
        }
    }
    
    deinit {
        webView.stopLoading()
        if (!hasRemoveKVO) {
            webView.scrollView.removeObserver(self, forKeyPath: #keyPath(UIScrollView.contentSize))
        }
    }
   
}

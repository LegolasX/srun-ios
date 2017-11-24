//
//  webViewController.swift
//  srun-ios
//
//  Created by Legolas Invoker on 2017/8/24.
//  Copyright © 2017年 Legolas Invoker. All rights reserved.
//

import UIKit
import WebKit
import SnapKit
import SwiftSpinner
class webViewController: UIViewController, UIScrollViewDelegate, WKNavigationDelegate{
    lazy var webView : WKWebView = {
        let web = WKWebView()
        web.navigationDelegate = self
        web.scrollView.delegate = self
        return web
    }()
    var userName : String?
    var password : String?
    let containerView = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(webView)
        webView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(30, 0, 0, 0))
        }
        
        let request = URLRequest(url:URL(string:"http://self.ncepu.edu.cn:8800")!)
        webView.scrollView.addObserver(self, forKeyPath: #keyPath(UIScrollView.contentSize), options: (NSKeyValueObservingOptions.new), context: nil)
        webView.load(request)
        self.view.addSubview(containerView)
        
        SwiftSpinner.useContainerView(containerView)
        containerView.snp.makeConstraints { (m) in
            m.center.equalToSuperview()
            m.size.equalTo(CGSize.init(width: 200, height: 200))
        }
        SwiftSpinner.show("loading")
    }
    func bigger(sender: UIButton) {
        webView.scrollView.setZoomScale(1.28228787897595, animated: true)
        webView.scrollView.setContentOffset(CGPoint.init(x: 814, y: 135), animated: true)
    }
    func smaller(sender: UIButton) {
        webView.scrollView.setZoomScale(0.5, animated: true)
        webView.scrollView.setContentOffset(CGPoint.init(x: 300, y: 200), animated: true)
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        print(scrollView.zoomScale)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset)
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
        guard let keyPath = keyPath else { return }
        print(keyPath)
        guard let newSize = change[NSKeyValueChangeKey.newKey] as? CGSize else { return }
        if webView.scrollView.zoomScale == 1.28228787897595 {
            webView.scrollView.removeObserver(self, forKeyPath: #keyPath(UIScrollView.contentSize))
            hasRemoveKVO = true
            self.webView.scrollView.setContentOffset(CGPoint.init(x: 814, y: 135), animated: true)
            SwiftSpinner.hide()
            containerView.removeFromSuperview()
            fillInBlack()
        }
        guard newSize.width == UIScreen.main.bounds.width && webView.isLoading == false else { return }
        if webView.scrollView.zoomScale != 1 {
            webView.scrollView.setZoomScale(1.28228787897595, animated: true)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
    }
    
    deinit {
        webView.stopLoading()

        if (!hasRemoveKVO) {
            webView.scrollView.removeObserver(self, forKeyPath: #keyPath(UIScrollView.contentSize))
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

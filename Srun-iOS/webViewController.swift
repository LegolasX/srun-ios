//
//  webViewController.swift
//  srun-ios
//
//  Created by Legolas Invoker on 2017/8/24.
//  Copyright © 2017年 Legolas Invoker. All rights reserved.
//

import UIKit
import WebKit
class webViewController: UIViewController {

    var htmlString : String?
    lazy var webView : WKWebView = {
        let web = WKWebView()
        return web
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init(htmlString: String) {
        self.init(nibName: nil, bundle: nil)
        self.htmlString = htmlString
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(webView)
        webView.loadHTMLString(htmlString!, baseURL: nil)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        webView.translatesAutoresizingMaskIntoConstraints = false
        super.viewWillLayoutSubviews()
        // align webView from the left and right
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": webView]))
        
        // align webView from the top and bottom
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": webView]))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

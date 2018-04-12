//
//  TodayViewController.swift
//  SrunToday
//
//  Created by Legolas.Invoker on 2017/12/3.
//  Copyright © 2017年 Legolas Invoker. All rights reserved.
//

import UIKit
import NotificationCenter
import SrunKit
import Fabric
import Crashlytics

class TodayViewController: UIViewController, NCWidgetProviding {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        Fabric.with([Crashlytics.self])
        Fabric.sharedSDK().debug = true
    }
    
    @IBOutlet weak var stateLabel: UILabel!
    
    var manager : LRSrunManger {
        return LRSrunManger.shared
    }
    
    @IBAction func logIn(_ sender: UIButton) {
        weak var wSelf = self
        if let pass = manager.defaultPassword, let user = manager.defaultUserName {
            manager.login(userName: user, password: pass, messageHandler: { message in
                wSelf!.stateLabel.text = message
                UIView.animate(withDuration: 0.5, animations: {
                    wSelf!.view.layoutIfNeeded()
                })
            })
            
        }
    }
    @IBAction func logOut(_ sender: UIButton) {
        weak var wSelf = self
        manager.logout { message in
            wSelf!.stateLabel.text = message
            UIView.animate(withDuration: 0.5, animations: {
                wSelf!.view.layoutIfNeeded()
            })
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}

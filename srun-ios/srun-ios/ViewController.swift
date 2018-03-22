//
//  ViewController.swift
//  srun-ios
//
//  Created by Legolas Invoker on 2017/8/22.
//  Copyright © 2017年 Legolas Invoker. All rights reserved.
//

import UIKit
import Alamofire
import WebKit
import Reachability
import SystemConfiguration.CaptiveNetwork
import SrunKit
class ViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var userNameLabel: SummerTextField!
    @IBOutlet weak var passwordLabel: SummerTextField!
    @IBOutlet weak var loginutton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var selfButton: UIButton!
    
    var manager : LRSrunManger {
        return LRSrunManger.shared
    }
    var passWord : String?  {
        return passwordLabel.text ?? manager.defaultPassword ?? nil
    }
    var userName : String? {
        return userNameLabel.text ?? manager.defaultUserName ?? nil
    }
    let reachability = Reachability()!
    
    var wifiStatus : Reachability.Connection = .none
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameLabel.delegate = self
        passwordLabel.delegate = self
        passwordLabel.attributedPlaceholder = NSAttributedString.init(string:"密码", attributes: [
            NSAttributedStringKey.foregroundColor:UIColor.white])
        userNameLabel.attributedPlaceholder = NSAttributedString.init(string:"学号", attributes: [
            NSAttributedStringKey.foregroundColor:UIColor.white])
        passwordLabel.text = manager.defaultPassword ?? ""
        userNameLabel.text = manager.defaultUserName ?? ""
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @objc func reachabilityChanged(note: Notification) {
        let reachability = note.object as! Reachability
        
        switch reachability.connection {
        case .wifi:
            print("Reachable via WiFi")
            let info = getWifiInfo()
            stateLabel.text = "当前接入的WI-FI为：\(info.ssid)"
            wifiStatus = .wifi
        case .cellular:
            stateLabel.text = "未连接WI-FI"
            print("Reachable via Cellular")
            wifiStatus = .cellular
        case .none:
            stateLabel.text = "未连接WI-FI"
            print("Network not reachable")
            wifiStatus = .none
        }
    }
    
    //#MARK: - actions
    @IBAction func login(_ sender: UIButton) {
        checkNetworkStatus {
            guard let userName = self.userName, let passWord = self.passWord else {
                self.stateLabel.text = "请输入用户名和密码"
                return
            }
            self.manager.login(userName: userName, password: passWord) { stateString in
                self.stateLabel.text = stateString
            }
        }
    }
    
    @IBAction func logout(_ sender: UIButton) {
        checkNetworkStatus {
            self.manager.logout{ stateString in
                self.stateLabel.text = stateString
            }
        }
    }
    
    @IBAction func status(_ sender: UIButton) {
        checkNetworkStatus {
            self.manager.status{ stateString in
                self.stateLabel.text = stateString
            }
        }
    }
    
    @IBAction func selfLogout(_ sender: GhostButton) {
        checkNetworkStatus {
            self.performSegue(withIdentifier: "web", sender: sender)
        }
    }
    
    func checkNetworkStatus(performBlock: @escaping (() -> Void)) {
        if wifiStatus == .wifi {
            performBlock()
        } else {
            let alert = UIAlertController(title: "还是4G呢", message: "先连上校园网", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "麻溜去连", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func getWifiInfo() -> (ssid: String, mac: String) {
        if let cfas: NSArray = CNCopySupportedInterfaces() {
            for cfa in cfas {
                if let dict = CFBridgingRetain(
                    CNCopyCurrentNetworkInfo(cfa as! CFString)
                    ) {
                    if let ssid = dict["SSID"] as? String,
                        let bssid = dict["BSSID"] as? String {
                        return (ssid, bssid)
                    }
                }
            }
        }
        return ("未知", "未知")
    }
    
    // MARK: - textField Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        weak var weak_self = self
        if (textField == passwordLabel) {
            manager.login(userName: userName, password: passWord) { stateString in
                weak_self?.stateLabel.text = stateString
            }
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        return true
    }
    
    //MARK: - segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier, identifier == "web", let vc = segue.destination as? webViewController {
            vc.password = self.passWord
            vc.userName = self.userName
        }
    }
}


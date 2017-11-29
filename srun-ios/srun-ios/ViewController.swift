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
class ViewController: UIViewController, UITextFieldDelegate{
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var userNameLabel: SummerTextField!
    @IBOutlet weak var passwordLabel: SummerTextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var selfButton: UIButton!

    // 629 - 649
    var passWord : String  {
        return passwordLabel.text ?? ""
    }
    var userName : String {
        return userNameLabel.text ?? ""
    }
    let reachability = Reachability()!
    
    var wifiStatus : Reachability.Connection = .none
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameLabel.delegate = self
        passwordLabel.delegate = self
        
        let defaults = UserDefaults.standard
        if let pass = defaults.value(forKey: "password") as? String {
            passwordLabel.text = pass
        }
        if let user = defaults.value(forKey: "username") as? String {
            userNameLabel.text = user
        }
        passwordLabel.attributedPlaceholder = NSAttributedString.init(string:"密码", attributes: [
            NSForegroundColorAttributeName:UIColor.white])
        userNameLabel.attributedPlaceholder = NSAttributedString.init(string:"学号", attributes: [
            NSForegroundColorAttributeName:UIColor.white])
        
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
    
    func reachabilityChanged(note: Notification) {
        
        let reachability = note.object as! Reachability
        
        switch reachability.connection {
        case .wifi:
            print("Reachable via WiFi")
            let info = getWifiInfo()
            stateLabel.text = "当前接入的WI-FI为：\(info.ssid)"
            wifiStatus = .wifi
//            LRSrunManger.shared.ping()
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
        weak var weak_self = self
        checkNetworkStatus {
            LRSrunManger.shared.loginB(userName: weak_self!.userName, password: weak_self!.passWord, retryTime: 3) { stateString in
                weak_self?.stateLabel.text = stateString
            }
        }
    }
    
    @IBAction func logout(_ sender: UIButton) {
        checkNetworkStatus {
            weak var weak_self = self
            LRSrunManger.shared.logout{ stateString in
                weak_self?.stateLabel.text = stateString
            }
        }
        
    }
    
    @IBAction func status(_ sender: UIButton) {
        LRSrunManger.shared.status()
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
    
    func dismissKeyboard() {
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
            LRSrunManger.shared.loginB(userName: userName, password: passWord, retryTime: 3) { stateString in
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


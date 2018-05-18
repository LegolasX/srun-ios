//
//  ViewController.swift
//  srun-ios
//
//  Created by Legolas Invoker on 2017/8/22.
//  Copyright © 2017年 Legolas Invoker. All rights reserved.
//

import UIKit
import WebKit
import Reachability
import SrunKit
import SafariServices
class ViewController: UIViewController, UITextFieldDelegate, UIGestureRecognizerDelegate{
    
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var userNameLabel: SummerTextField!
    @IBOutlet weak var passwordLabel: SummerTextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var selfButton: UIButton!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var moneyButton: UIButton!
    @IBOutlet weak var accountButton: UIButton!
    @IBOutlet weak var testButton: GhostButton!
    
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
    
    var moneyURL : String?
    //#MARK:- life circle
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameLabel.delegate = self
        passwordLabel.delegate = self
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        manager.helperShow { [weak self] (url, shouldHide)  in
            self?.moneyButton.isHidden = shouldHide
            self?.moneyURL = url
        }
        setupViews()
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
    }
    
    func setupViews() {
        userNameLabel.attributedPlaceholder = NSAttributedString.init(string:"学号", attributes: [
            NSAttributedStringKey.foregroundColor:UIColor.white])
        userNameLabel.keyboardType = .numberPad
        userNameLabel.returnKeyType = .next
        
        passwordLabel.attributedPlaceholder = NSAttributedString.init(string:"密码", attributes: [
            NSAttributedStringKey.foregroundColor:UIColor.white])
        passwordLabel.keyboardType = .alphabet
        passwordLabel.returnKeyType = .go
        passwordLabel.autocorrectionType = .no
        passwordLabel.isSecureTextEntry = true
        passwordLabel.text = manager.defaultPassword ?? ""
        userNameLabel.text = manager.defaultUserName ?? ""
        
        accountButton.setTitle("▲", for: .normal)
        accountButton.setTitle("▼", for: .selected)
        accountButton.setTitle("▼", for: .highlighted)
        accountButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        accountButton.layer.shadowColor = UIColor.blue.withAlphaComponent(0.8).cgColor
        #if RELEASE
        testButton.isHidden = true
        #endif
    }
    //#MARK:- non-direct-user actions
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
    
    func openWebView(from HTMLString:String) {
        let webVC = webViewController(htmlString:HTMLString)
        self.navigationController?.pushViewController(webVC, animated: true)
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
    
    //#MARK: - user actions
    @IBAction func login(_ sender: UIButton) {
        checkNetworkStatus {
            guard let userName = self.userName, let passWord = self.passWord else {
                self.stateLabel.text = "请输入用户名和密码"
                return
            }
            self.manager.login(userName: userName, password: passWord) { success, resultString in
                if success {
                    self.stateLabel.text = resultString
                } else {
                    self.openWebView(from: resultString)
                }
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
            self.manager.status{ success, stateString in
                self.stateLabel.text = stateString
            }
        }
    }
    
    @IBAction func selfLogout(_ sender: GhostButton) {
        checkNetworkStatus {
            let url = URL(string: "http://202.204.67.15:8900")
            let safariVC = SFSafariViewController(url: url!)
            self.present(safariVC, animated: true, completion: nil)
        }
    }
    @IBAction func tempTest(_ sender: UIButton) {
        if let anotherVC = storyboard?.instantiateViewController(withIdentifier: "mainPage") {
            self.navigationController?.pushViewController(anotherVC, animated: true)
        }
    }
    
    @IBAction func getMoney(_ sender: UIButton) {
        let url = URL(string: moneyURL ?? "http://oeino.cn/post/5ad40fd6825ccf3095579b44")
        let safariVC = SFSafariViewController(url: url!)
        self.present(safariVC, animated: true, completion: nil)
    }
    
    @IBAction func changeAccount(_ sender: UIButton) {
        accountButton.isSelected = !accountButton.isSelected
        guard accountButton.isSelected else { return }
        let alert = UIAlertController(title: "请选择你的账号", message: "成功登陆之后可以保存账户密码", preferredStyle: .actionSheet)
        var accounts : [singleAccount] = manager.allAccounts ?? []
        for (index,account) in accounts.enumerated() {
            let action = UIAlertAction(title: account.userName, style: .default) { (action) in
                accounts.remove(at: index)
                accounts.insert(account, at: 0)
                self.manager.allAccounts = accounts
                self.userNameLabel.text = account.userName
                self.passwordLabel.text = account.password
                self.accountButton.isSelected = !self.accountButton.isSelected
            }
            alert.addAction(action)
        }
        //这里是为了适配iPad 否则会有崩溃
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { _ in
            self.accountButton.isSelected = !self.accountButton.isSelected
        }))
        self.present(alert, animated: true) {
        }
    }
    
    // MARK: - textField Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if (textField == passwordLabel) {
            self.login(self.loginButton)
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        return true
    }
    
    //#MARK:gesture delegate
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.navigationController?.viewControllers.count == 1{
            return false;
        }
        return true;
    }
    
}


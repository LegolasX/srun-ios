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
class ViewController: UIViewController, UITextFieldDelegate{
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var userNameLabel: SummerTextField!
    @IBOutlet weak var passwordLabel: SummerTextField!
//    @IBOutlet weak var consoleView: UITextView!
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameLabel.delegate = self
        passwordLabel.delegate = self
        navigationController?.navigationBar.tintColor = UIColor.red
        navigationController?.navigationBar.subviews[1].alpha = 0
        
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
    }
    
    @IBAction func backgroundTaped(_ sender: UIControl) {
        self.view.endEditing(true)
    }
    @IBAction func login(_ sender: UIButton) {
        weak var weak_self = self
        LRSrunManger.shared.loginB(userName: userName, password: passWord, retryTime: 3) { stateString in
            weak_self?.stateLabel.text = stateString
        }
    }
    
    @IBAction func logout(_ sender: UIButton) {
        weak var weak_self = self
        LRSrunManger.shared.logout{ stateString in
            weak_self?.stateLabel.text = stateString
        }
    }
    
    @IBAction func status(_ sender: UIButton) {
        LRSrunManger.shared.status()
    }
    
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
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier, identifier == "web", let vc = segue.destination as? webViewController {
            vc.password = self.passWord
            vc.userName = self.userName
        }
        
    }
}


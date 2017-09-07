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
    @IBOutlet weak var userNameLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
//    @IBOutlet weak var consoleView: UITextView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var selfButton: UIButton!

    // 629 - 649
    var passWord : String  {
        return passwordLabel.text == "" ? "li777qing" : passwordLabel.text!
    }
    
    var userName : String {
        return userNameLabel.text == "" ? "1141250201" : userNameLabel.text!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameLabel.delegate = self
        passwordLabel.delegate = self
        
    }
    
    @IBAction func backgroundTaped(_ sender: UIControl) {
        self.view.endEditing(true)
    }
    @IBAction func login(_ sender: UIButton) {
        LRSrunManger.shared.login(userName: self.userName, password: self.passWord)
    }
    
    @IBAction func logout(_ sender: UIButton) {
        LRSrunManger.shared.logout()
    }
    
    @IBAction func status(_ sender: UIButton) {
        LRSrunManger.shared.status()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        if (textField == passwordLabel) {
            LRSrunManger.shared.login(userName: self.userName, password: self.passWord)
        }
        return true;
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


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
    @IBOutlet weak var consoleView: UITextView!
    
    var params : Parameters {
        get {
            return [
                "username": self.userName,
                "password": self.encrypt(with:self.passWord, by: self.timeStamp),
                "drop":"0",
                "type":"10",
                "n":"117",
                "pop":"0",
                "ac_type":"h3c",
                "mac":""
            ]
        }
    }
    var timeStamp : Int {
        let time = Int(Date().timeIntervalSince1970) - (stampDifference ?? 639)
        myPrint("myStamp: \(time)")
        return time
    }
    
    var lastStamp : Int
    
    var stampDifference : Int?
    // 629 - 649
    var passWord : String  {
        return passwordLabel.text == "" ? "li777qing" : passwordLabel.text!
    }
    
    var userName : String {
        return userNameLabel.text == "" ? "1141250201" : userNameLabel.text!
    }
    
    static var ip : String = "202.204.67.15"
    static var port : String = "3333"
    static var ipPort : String {
        return "http://" + ip + (port == "" ? "" :":\(port)") + "/cgi-bin/"
        
    }
    struct urlStrings {
        static let loginURL = ipPort  + "do_login"
        static let forceLogoutURL = ipPort  + "force_logout"
        static let logoutURL = ipPort  + "do_logout"
        static let statusURL = ipPort  + "keeplive"
    }
    
    struct selfServiceURLs {
        static let indexURL = "http://self.ncepu.edu.cn:8800"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        consoleView.text = ""
        userNameLabel.delegate = self
        passwordLabel.delegate = self
        
    }
    
    func myPrint(_ des:String)  {
        consoleView.text = consoleView.text + des + "\n"
        print(des)
    }
    
    @IBAction func backgroundTaped(_ sender: UIControl) {
        self.view.endEditing(true)
    }
    @IBAction func login(_ sender: UIButton) {
        login()
    }
    
    @IBAction func logout(_ sender: UIButton) {
        logout()
    }
    
    @IBAction func forceLogout(_ sender: UIButton) {
        forceLogout()
    }
    
    @IBAction func status(_ sender: UIButton) {
        status()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        if (textField == passwordLabel) {
            login()
        }
        return true;
    }
    func status() {
        consoleView.text = ""
        getRequest(url: urlStrings.statusURL, with: nil) { (response) in
            guard let data = response.data, let utf8Text = String(data: data, encoding: .utf8)  else { return }
            self.myPrint(utf8Text)
        }
    }
    
    func logout() {
        consoleView.text = ""
        getRequest(url: urlStrings.logoutURL, with: nil) { (response) in
        guard let data = response.data, let utf8Text = String(data: data, encoding: .utf8)  else { return }
            self.myPrint(utf8Text)
        }
        
    }
    
    func forceLogout() {
        consoleView.text = ""
    }
    
    
    
    func login() {
//        consoleView.text = ""
        postRequest(url: urlStrings.loginURL, with: params, success: { response in
            guard let data = response.data, let utf8Text = String(data: data, encoding: .utf8)  else { return }
            let parts = utf8Text.components(separatedBy: "@")
            guard parts.count == 2, let newTimeStamp = Int(parts[1]) else {
                if utf8Text.components(separatedBy: ",").count == 5 {
                    self.myPrint("login success")
                }
                self.myPrint(utf8Text)
                return
            }
            var newParameters = self.params
            newParameters["password"] = self.encrypt(with: self.passWord, by:newTimeStamp)
            self.myPrint("server timeStamp: (newTimeStamp)")
            self.postRequest(url: urlStrings.loginURL, with: newParameters, success: { (data) in
                guard let anotherData = data.data, let anotherUtf8Text = String(data: anotherData, encoding: .utf8)  else { return }
                self.myPrint("\(anotherUtf8Text)")
                self.myPrint("login success")
            })
        })
    }
    
    func getRequest(url: String, with parameters : Parameters?, success handler: @escaping (DataResponse<Data>) -> Void) {
        self.request(url: url, method: .get, with: parameters, success: handler)
    }
    
    func postRequest(url: String, with parameters : Parameters?, success handler: @escaping (DataResponse<Data>) -> Void) {
        self.request(url: url, method: .post, with: parameters, success: handler)
    }
    
    func request(url: String,
                 method: HTTPMethod,
                 with parameters : Parameters?,
                 success handler: @escaping (DataResponse<Data>) -> Void) {
        let headers : HTTPHeaders = [
            "Accept-Type":"text/html"
        ]
        var params = Parameters()
        if let p = parameters {
            params = p
        }
        Alamofire.request(url, method: method, parameters: params, headers: headers).responseData { (response) in
            guard response.result.isSuccess != false else {
                self.myPrint("Error: \(String(describing: response.error))")
                return
            }
            self.myPrint("Request: \(String(describing: response.request))")
            self.myPrint("Response: \(String(describing: response.response))")
            handler(response)
        }
        
    }
    
    func encrypt(with password: String, by timeStamp: Int) -> String {
        var string =  ""
        let key = String(timeStamp / 60) as NSString
        let password = password as NSString
        for i in 0..<password.length {
            let p = password.character(at: i)
            let index = key.length - i % key.length - 1
            let k = key.character(at: index) ^ p
            let l = (k&0x0f) + 0x36;
            let h = ((k>>4)&0x0f) + 0x63;
            let lString = String(describing: UnicodeScalar(l)!)
            let hString = String(describing: UnicodeScalar(h)!)
            if (i%2 == 1) {
                string.append(hString)
                string.append(lString)
            } else {
                string.append(lString)
                string.append(hString)
            }
        }
        return string;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier, identifier == "web", let vc = segue.destination as? webViewController {
            vc.password = self.passWord
            vc.userName = self.userName
        }
        
    }
}


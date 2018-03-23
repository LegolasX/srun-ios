//
//  LRSrunManger.swift
//  srun-ios
//
//  Created by Legolas Invoker on 2017/9/5.
//  Copyright © 2017年 Legolas Invoker. All rights reserved.
//

import Foundation


public final class LRSrunManger: NSObject {
    
    
    public static let shared = LRSrunManger()
    private override init() {}
    
    let defaults = UserDefaults.init(suiteName: "group.shared.defaults")!
    
    struct urlStrings {
        static let logInOutURL = "http://202.204.67.15/srun_portal_phone.php"
        static let statusURL = "http://202.204.67.15/srun_portal_pc_succeed.php"
    }
    
    struct userDefaultsKey {
        static let userName = "username"
        static let password = "password"
    }
    
    public var defaultPassword : String? {
        return defaults.value(forKey: userDefaultsKey.password) as? String
    }
    
    public var defaultUserName : String? {
        return defaults.value(forKey: userDefaultsKey.userName) as? String
    }

    func packingLoginParams(userName:String, password: String) -> [String : Any] {
        return [
            "action"  : "login",
            "ac_id"   : "1",
            "user_ip" : "",
            "nas_ip"  : "",
            "user_mac": "",
            "save_me" : "1",
            "username": userName,
            "password": password
        ]
    }
    
    var userIP : String?
    var action : String?
    var info : String?
    
    public  func login(userName user:String, password:String, messageHandler:@escaping ((String) -> Void)) {
        let loginPhoneParam = packingLoginParams(userName: user, password: password)
        postRequest(url: urlStrings.logInOutURL, parameters: loginPhoneParam, successHandler: { response in
            guard let data = response.data, let utf8Text = String(data: data, encoding: .utf8)  else { return }
            print(utf8Text)
            self.info = getParsedValue(nodeName: "input", attributeTitle: "name", attributeValue: "info", value: "value", html: utf8Text)
            self.action = getParsedValue(nodeName: "input", attributeTitle: "name", attributeValue: "action", value: "value", html: utf8Text)
            self.userIP = getParsedValue(nodeName: "input", attributeTitle: "name", attributeValue: "user_ip", value: "value", html: utf8Text)
            if let success = getParsedValue(nodeName: "div", attributeTitle: "id", attributeValue: "login_ok_date", value: nil, html: utf8Text) {
                messageHandler(success.trimmingCharacters(in: .whitespacesAndNewlines))
                self.defaults.set(user, forKey: userDefaultsKey.userName)
                self.defaults.set(password, forKey: userDefaultsKey.password)
            } else {
                messageHandler("登录失败")
            }
        })
    }
    
    public  func status(messageHandler:@escaping ((String) -> Void)) {
        getRequest(url: urlStrings.statusURL, parameters: nil) { (response) in
            guard let data = response.data, let utf8Text = String(data: data, encoding: .utf8)  else { return }
            print(utf8Text)
            guard
                let userBalance = getParsedValue(nodeName: "span", attributeTitle: "id", attributeValue: "user_balance", value: nil, html: utf8Text),
                let sumSeconds = getParsedValue(nodeName: "span", attributeTitle: "id", attributeValue: "sum_seconds", value: nil, html: utf8Text),
                let sumBytes = getParsedValueWith("(//span[@id='sum_bytes'])[2]", from: utf8Text, for: nil),
                let userName = getParsedValue(nodeName: "span", attributeTitle: "id", attributeValue: "user_name", value: nil, html: utf8Text)
                else {
                    return
            }
            print(userBalance,sumSeconds,sumBytes,userName)
        }
    }
    
    public func logout(messageHandler:@escaping ((String) -> Void)) {
        guard let info = self.info, let action = self.action, let ip = self.userIP else {
            messageHandler("尚未登录")
            return
        }
        let logoutParam = ["action" : action, "info" : info, "user_ip" : ip]
        postRequest(url: urlStrings.logInOutURL, parameters: logoutParam) { (response) in
            guard let data = response.data, let utf8Text = String(data: data, encoding: .utf8)  else {
                messageHandler("登录失败")
                return
            }
            print(utf8Text)
            if let success = getParsedValue(nodeName: "div", attributeTitle: "id", attributeValue: "login_ok_date", value: nil, html: utf8Text) {
                messageHandler(success.trimmingCharacters(in: .whitespacesAndNewlines))
            }
        }
    }
    //        let paramPC = ["action" : "login", "username" : "1141250201", "password" : "li777qing", "ac_id" : "1", "user_ip" : "", "nas_ip" : "", "user_mac" : "", "save_me" : "0", "ajax" : "1"]
    //        let pcURL = "http://202.204.67.15/include/auth_action.php"
    
}

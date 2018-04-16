//
//  LRSrunManger.swift
//  srun-ios
//
//  Created by Legolas Invoker on 2017/9/5.
//  Copyright © 2017年 Legolas Invoker. All rights reserved.
//

import Foundation
import StoreKit
public struct singleAccount : Codable{
    public let userName : String
    public var password : String
}
public final class LRSrunManger: NSObject {
    
    
    public static let shared = LRSrunManger()
    private override init() {}
    
    let defaults = UserDefaults.init(suiteName: "group.shared.defaults")!
    
    struct urlStrings {
        static let logInOutURL = "http://202.204.67.15/srun_portal_phone.php"
        static let statusURL = "http://202.204.67.15/srun_portal_pc_succeed.php"
        static let helperURL = "http://140.143.164.218/api/iosInfo"
    }
    
    public struct userDefaultsKey {
        static let userName = "username"
        static let password = "password"
        static let accountKey = "accounts"
        static let loginTimeKey = "loginTime"
    }
    
    public var allAccounts: [singleAccount]? {
        set {
            defaults.set(try? PropertyListEncoder().encode(newValue!), forKey:userDefaultsKey.accountKey)
        }
        get {
            if let data = defaults.value(forKey:userDefaultsKey.accountKey) as? Data {
                return try? PropertyListDecoder().decode(Array<singleAccount>.self, from: data)
            }
            return nil
        }
    }
    
    public var defaultPassword : String? {
        return allAccounts?.first?.password
    }
    
    public var defaultUserName : String? {
        return allAccounts?.first?.userName
    }
    
    var loginSuccessTime : Int {
        set {
            if newValue == 10 || newValue == 50 || newValue == 100 || newValue % 500 == 0{
                if #available(iOSApplicationExtension 10.3, *) {
                    SKStoreReviewController.requestReview()
                }
            }
            defaults.set(newValue, forKey: userDefaultsKey.loginTimeKey)
        }
        get {
            return defaults.integer(forKey: userDefaultsKey.loginTimeKey)
        }
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
    
    func appendSingleAccount(someAccount:singleAccount) {
        if var accounts = self.allAccounts {
            var flag = false
            for (index, account) in accounts.enumerated() {
                if account.userName == someAccount.userName {
                    accounts.remove(at: index)
                    accounts.insert(account, at: 0)
                    accounts[0].password = someAccount.password
                    self.allAccounts = accounts
                    flag = true
                }
            }
            if !flag {
                accounts.insert(someAccount, at: 0)
                self.allAccounts = accounts
            }
        } else {
            self.allAccounts = [someAccount]
        }
    }
    
    public  func login(userName user:String, password:String, messageHandler:@escaping ((String) -> Void)) {
        let loginPhoneParam = packingLoginParams(userName: user, password: password)
        postRequest(url: urlStrings.logInOutURL, parameters: loginPhoneParam, successHandler: { response in
            guard let data = response.data, let utf8Text = String(data: data, encoding: .utf8)  else { return }
            print(utf8Text)
            self.info = getParsedValue(nodeName: "input", attributeTitle: "name", attributeValue: "info", value: "value", html: utf8Text)
            self.action = getParsedValue(nodeName: "input", attributeTitle: "name", attributeValue: "action", value: "value", html: utf8Text)
            self.userIP = getParsedValue(nodeName: "input", attributeTitle: "name", attributeValue: "user_ip", value: "value", html: utf8Text)
            if let _ = getParsedValue(nodeName: "div", attributeTitle: "id", attributeValue: "login_ok_date", value: nil, html: utf8Text) {
                self.status(messageHandler: messageHandler)
                self.appendSingleAccount(someAccount: singleAccount(userName: user, password: password))
                self.loginSuccessTime = self.loginSuccessTime + 1
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
                var sumSeconds = getParsedValue(nodeName: "span", attributeTitle: "id", attributeValue: "sum_seconds", value: nil, html: utf8Text),
                let sumBytes = getParsedValueWith("(//span[@id='sum_bytes'])[2]", from: utf8Text, for: nil),
                let userName = getParsedValue(nodeName: "span", attributeTitle: "id", attributeValue: "user_name", value: nil, html: utf8Text)
                else {
                    return
            }
            if sumSeconds.contains("小时") {
                sumSeconds = "\(sumSeconds.components(separatedBy: "时")[0])时"
            }
            let status = "已使用\(sumSeconds) 计费组：\((userBalance.dropFirst() as NSString).integerValue)"
            print(userBalance,sumSeconds,sumBytes,userName)
            messageHandler(status)
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
    //TODO:  later!
    public func helperShow(messageHandler:@escaping ((String,Bool) -> Void)) {
        getRequest(url: urlStrings.helperURL, parameters: nil) { (response) in
            guard let data = response.data else { return }
            if let helper = try? JSONDecoder().decode(Helper.self, from: data) {
                messageHandler(helper.data.url,helper.data.shouldShow)
                print(helper)
            }
        }
    }

    struct HelperData : Codable {
        let shouldShow : Bool
        let url : String
    }
    
    struct Helper: Codable {
        let code : Int
        let data : HelperData
        let message : String
    }
    
    
    //        let paramPC = ["action" : "login", "username" : "1141250201", "password" : "li777qing", "ac_id" : "1", "user_ip" : "", "nas_ip" : "", "user_mac" : "", "save_me" : "0", "ajax" : "1"]
    //        let pcURL = "http://202.204.67.15/include/auth_action.php"
    
}

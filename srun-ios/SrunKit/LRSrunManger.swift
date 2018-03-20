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
    
    public var defaultPassword : String? {
        let defaults = UserDefaults.init(suiteName: "group.shared.defaults")!
        if let pass = defaults.value(forKey: "password") as? String {
            return pass
        }
        return nil
    }
    
    public var defaultUserName : String? {
        let defaults = UserDefaults.init(suiteName: "group.shared.defaults")!
        if let username = defaults.value(forKey: "username") as? String {
            return username
        }
        return nil
    }
    
    var params : [String: Any] {
        get {
            return [
                "drop":"0",
                "type":"10",
                "n":"117",
                "pop":"0",
                "ac_type":"h3c",
                "mac":""
            ]
        }
    }
    
    static var ip : String = "202.204.67.15"
    static var port : String = "3333"
    static var ipPort : String {
        return "http://" + ip + (port == "" ? "" :":\(port)") + "/cgi-bin/"
        
    }
    struct urlStrings {
        static let loginURL = ipPort  + "do_login/"
        static let forceLogoutURL = ipPort  + "force_logout"
        static let logoutURL = ipPort  + "do_logout/"
        static let statusURL = ipPort  + "keeplive"
    }
    
    struct selfServiceURLs {
        static let indexURL = "http://self.ncepu.edu.cn:8800"
    }
    
    public func logout(messageHandler:@escaping ((String) -> Void)) {
        let phoneURL = "http://202.204.67.15/srun_portal_phone.php"
        let logoutParam = ["action" : "logout", "username" : "1141250201", "password" : "li777qing", "ajax" : "1"]
        getRequest(url: phoneURL, with: logoutParam) { (response) in
            guard let data = response.data, let utf8Text = String(data: data, encoding: .utf8)  else { return }
            print(utf8Text)
            messageHandler(utf8Text)
        }
    }
    
    public  func loginB(userName user:String, password:String, retryTime:NSInteger, messageHandler:@escaping ((String) -> Void)) {
        let loginPhoneParam = ["action" : "login","ac_id"    : "1","user_ip"    : "","nas_ip"    : "","user_mac"    : "","username"    : "1141250201","password"    : "li777qing","save_me"    : "1"]
        let phoneURL = "http://202.204.67.15/srun_portal_phone.php"
        postRequest(url: phoneURL, with: loginPhoneParam, success: { response in
            guard let data = response.data, let utf8Text = String(data: data, encoding: .utf8)  else { return }
            print(utf8Text)
        })
    }
    
    public  func status(messageHandler:@escaping ((String) -> Void)) {
        getRequest(url: "http://202.204.67.15/srun_portal_pc_succeed.php", with: nil) { (response) in
            guard let data = response.data, let utf8Text = String(data: data, encoding: .utf8)  else { return }
            print(utf8Text)
        }
    }
    
    //        let paramPC = ["action" : "login", "username" : "1141250201", "password" : "li777qing", "ac_id" : "1", "user_ip" : "", "nas_ip" : "", "user_mac" : "", "save_me" : "0", "ajax" : "1"]
    
    //        let pcURL = "http://202.204.67.15/include/auth_action.php"
    
}

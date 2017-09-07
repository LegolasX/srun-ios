//
//  LRSrunManger.swift
//  srun-ios
//
//  Created by Legolas Invoker on 2017/9/5.
//  Copyright © 2017年 Legolas Invoker. All rights reserved.
//

import Foundation
import UIKit
final class LRSrunManger: NSObject {
    
    
    static let shared = LRSrunManger()
    private override init() {}
    
    
    var params : [String: Any] {
        get {
            return [
                //                "username": self.userName,
                //                "password": self.encrypt(with:self.passWord, by: self.timeStamp),
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
        lastStamp = Int(Date().timeIntervalSince1970)
        let time = lastStamp! - (stampDifference ?? 639)
        return time
    }
    
    var lastStamp : Int?
    var stampDifference : Int?
    // 629 - 649
    
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
    
    enum SrunState : String{
        case usertabError = "user_tab_error"
        case userNameError = "username_error"
        case nonAuthError = "non_auth_error"
        case passwordError = "password_error"
        case statusError = "status_error"
        case availableError = "available_error"
        case ipExistError = "ip_exist_error"
        case userNumError = "usernum_error"
        case onlinenumError = "online_num_error"
        case modeError = "mode_error"
        case timepolicyError = "time_policy_error"
        case fluxError = "flux_error"
        case minutesError = "minutes_error"
        case ipError = "ip_error"
        case macError = "mac_error"
        case syncError = "sync_error"
        case logoutOk = "logout_ok"
        case logoutError = "logout_error"
        
        var stateString : String {
            switch self {
            case .usertabError : return "认证程序未启动"
            case .userNameError : return "用户名错误"
            case .nonAuthError : return "您无须认证，可直接上网"
            case .passwordError : return "密码错误"
            case .statusError : return "用户已欠费，请尽快充值。"
            case .availableError : return "用户已禁用"
            case .ipExistError : return "您的IP尚未下线，请等待2分钟再试。"
            case .userNumError : return "用户数已达上限"
            case .onlinenumError : return "该帐号的登录人数已超过限额\n如果怀疑帐号被盗用，请联系管理员。"
            case .modeError : return "系统已禁止WEB方式登录，请使用客户端"
            case .timepolicyError : return "当前时段不允许连接"
            case .fluxError : return "您的流量已超支"
            case .minutesError : return "您的时长已超支"
            case .ipError : return "您的IP地址不合法"
            case .macError : return "您的MAC地址不合法"
            case .syncError : return "您的资料已修改，正在等待同步，请2分钟后再试。"
            case .logoutOk : return "注销成功，请等1分钟后登录。"
            case .logoutError : return "您不在线上"
            }
        }
    }
    
        
        func logout() {
            getRequest(url: urlStrings.logoutURL, with: nil) { (response) in
                guard let data = response.data, let utf8Text = String(data: data, encoding: .utf8)  else { return }
                print(utf8Text)
            }
            
        }
        
        func status() {
            getRequest(url: urlStrings.statusURL, with: nil) { (response) in
                guard let data = response.data, let utf8Text = String(data: data, encoding: .utf8)  else { return }
                print(utf8Text)
            }
        }
        
    func login(userName user:String, password:String) {
            postRequest(url: urlStrings.loginURL, with: params, success: { response in
                guard let data = response.data, let utf8Text = String(data: data, encoding: .utf8)  else { return }
                let parts = utf8Text.components(separatedBy: "@")
                guard parts.count == 2, let newTimeStamp = Int(parts[1]) else {
                    print(utf8Text) // 如果返回不是由@分开，有两个部分 那么就是登陆错误 log一下 然后退出
                    return
                }
                if utf8Text.components(separatedBy: ",").count == 5 {
                    print("login success") //如果由,分割成5个 就是登陆成功 也log 然后退出
                    return
                }
                //到了这里 就是密码错误了 可能是因为密码错误 也可能是服务器傻逼
                //TODO: 记得处理真的是密码错误的情况
                print("server timeStamp: (newTimeStamp)")
                var newParameters = self.params
                self.stampDifference = self.lastStamp! - newTimeStamp
                newParameters["password"] = self.encrypt(with: password, by:self.timeStamp)
                postRequest(url: urlStrings.loginURL, with: newParameters, success: { (data) in
                    guard let anotherData = data.data, let anotherUtf8Text = String(data: anotherData, encoding: .utf8)  else { return }
                    print("\(anotherUtf8Text)")
                    print("login success")
                })
            })
        }
        
        private func encrypt(with password: String, by timeStamp: Int) -> String {
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
        
}

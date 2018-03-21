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
        let html = "<!DOCTYPE html><html class=\"ui-mobile\">    <head id=\"ctl00_Head\">        <meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">        <base href=\".\">        <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">        <meta name=\"format-detection\" content=\"telephone=no\">        <title>登录</title>        <link rel=\"stylesheet\" href=\"./css/bootstrap.min.css\">        <script src=\"./js/jquery-1.11.3.min.js\"></script>        <script src=\"./js/bootstrap.min.js\"></script>                    <script language=\"javascript\" src=\"js/srun_portal.js\"></script>    <style type=\"text/css\">        body{            background:url(images/phone1bg_1.png);            margin:0 auto;            padding:0px 0px;            margin:0px 0px;            height:500px;            }        .form-signin {            max-width:330px;            padding:15px;            margin:0 auto;            }        input {            margin-bottom:8px;            }        label {            margin-left:20px;            }        .navbar {            background-color:#1997ec;            text-align:center;            margin:0 auto;            border-bottom:1px solid #9C0;            }        .img-responsive {            text-align:center;            margin:0 auto;            }        .notice {            color:#C00;            }        .bg {            position:absolute;            z-index:-1;            height:289px;            width:280px;            bottom:0px;            left:0px;            background:url(images/phone1bg.png) no-repeat;            }        label {            font-weight:100;            padding:5px 5px;            }        .forget {            width:96%;            text-align:right;            }        .forget a {            text-decoration:underline;            }    </style>            </head>    <body class=\"ui-mobile-viewport ui-overlay-b\" onkeydown=\"BindEnter(event)\"><nav class=\"navbar\">    <img src=\"images/phone1logo.png\" width=\"330\" height=\"110\" border=\"0\" /></nav><nav class=\"bg\"></nav><div class=\"container\">                                <h5><br/></h5>                                                <form name=\"form3\" method=\"post\" action=\"srun_portal_phone.php?ac_id=1\" id=\"login_form\" class=\"form-signin\" onSubmit=\"return do_login()\">                            <input type=\"hidden\" name=\"action\" value=\"auto_logout\">                            <input type=\"hidden\" name=\"info\" value=\"bQ0pOyR6IX/u0akbf5QES0glrNeCGpyO0W6Rspy5eqNn6nc4gW3fNXOwIvKINohEwt+I5+9eRM4aYtjFVXhJvUolIug5QGD7xuiOkHn3ImcShwTFxKwf7RaYNUs8elDe96NZMMOkS6qkGJtYr2iRCou7/TCEREAbQ4OhUYtTODhO4iF6Jt51Iv1F6XDA\">                            <input type=\"hidden\" name=\"user_ip\" value=\"10.112.174.75\">                            <div style=\" text-align: center; padding:20px 0 20px;font-size: 24px; color:orange\" id=\"login_ok_date\">                                网络已连接                            </div>                                                                                            <input type=\"submit\" class=\"btn btn-md btn-primary btn-block\" value=\"注销\">&nbsp;&nbsp;                                                                                        </form>                                    </div>"

        if let value = getParsedValue(nodeName: "input", attributeTitle: "name", attributeValue: "info", value: "value", html: html) {
            print(value)
        }
        if let value = getParsedValue(nodeName: "div", attributeTitle: "id", attributeValue: "login_ok_date", value: nil, html: html) {
            print(value)
        }
        postRequest(url: phoneURL, with: loginPhoneParam, success: { response in
            guard let data = response.data, let utf8Text = String(data: data, encoding: .utf8)  else { return }
            print(utf8Text)
            if let value = getParsedValue(nodeName: "input", attributeTitle: "name", attributeValue: "info", value: "value", html: utf8Text) {
                print(value)
            }
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

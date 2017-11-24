//
//  LRFire.swift
//  srun-ios
//
//  Created by Legolas Invoker on 2017/9/5.
//  Copyright © 2017年 Legolas Invoker. All rights reserved.
//

import Foundation
import Alamofire
//class LRFire: NSObject {

func getRequest(url: String, with parameters : Parameters?, success handler: @escaping (DataResponse<Data>) -> Void) {
    request(url: url, method: .get, with: parameters, success: handler)
}

func postRequest(url: String, with parameters : Parameters?, success handler: @escaping (DataResponse<Data>) -> Void) {
    request(url: url, method: .post, with: parameters, success: handler)
}

private func request(url: String,
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
                            print("Error: \(String(describing: response.error))")
            //TODO: fix this error showing 
            //Optional(Error Domain=NSURLErrorDomain Code=-1004 "Could not connect to the server." UserInfo={NSUnderlyingError=0x170243cf0 {Error Domain=kCFErrorDomainCFNetwork Code=-1004 "(null)" UserInfo={_kCFStreamErrorCodeKey=64, _kCFStreamErrorDomainKey=1}}, NSErrorFailingURLStringKey=http://202.204.67.15:3333/cgi-bin/do_login, NSErrorFailingURLKey=http://202.204.67.15:3333/cgi-bin/do_login, _kCFStreamErrorDomainKey=1, _kCFStreamErrorCodeKey=64, NSLocalizedDescription=Could not connect to the server.})
            return
        }
                   // print("Request: \(String(describing: response.request))")
                    //print("Response: \(String(describing: response.response))")
        handler(response)
    }
}

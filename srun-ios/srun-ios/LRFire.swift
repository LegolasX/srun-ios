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
            //                self.myPrint("Error: \(String(describing: response.error))")
            return
        }
        //            self.myPrint("Request: \(String(describing: response.request))")
        //            self.myPrint("Response: \(String(describing: response.response))")
        handler(response)
    }
}

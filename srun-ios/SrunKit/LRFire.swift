//
//  LRFire.swift
//  srun-ios
//
//  Created by Legolas Invoker on 2017/9/5.
//  Copyright © 2017年 Legolas Invoker. All rights reserved.
//

import Foundation
import Alamofire

func getRequest(url: String, parameters param: Parameters?, successHandler handler: @escaping (DataResponse<Data>) -> Void) {
    request(url: url, method: .get, with: param, success: handler)
}

func postRequest(url: String, parameters param : Parameters?, successHandler handler: @escaping (DataResponse<Data>) -> Void) {
    request(url: url, method: .post, with: param, success: handler)
}

private func request(url: String,
                     method: HTTPMethod,
                     with parameters : Parameters?,
                     success handler: @escaping (DataResponse<Data>) -> Void) {
    let headers : HTTPHeaders = [
        "Accept-Type":"text/html"
    ]
    Alamofire.request(url, method: method, parameters: parameters ?? nil, headers: headers).responseData { (response) in
        guard response.result.isSuccess != false else {
            print("Error: \(String(describing: response.error))")
            return
        }
        handler(response)
    }
}

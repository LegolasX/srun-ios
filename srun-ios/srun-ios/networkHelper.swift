//
//  networkHelper.swift
//  srun-ios
//
//  Created by Legolas.Invoker on 2018/3/22.
//  Copyright © 2018年 Legolas Invoker. All rights reserved.
//

import Foundation
import SystemConfiguration.CaptiveNetwork

func getWifiInfo() -> (ssid: String, mac: String) {
    if let cfas: NSArray = CNCopySupportedInterfaces() {
        for cfa in cfas {
            if let dict = CFBridgingRetain(
                CNCopyCurrentNetworkInfo(cfa as! CFString)
                ) {
                if let ssid = dict["SSID"] as? String,
                    let bssid = dict["BSSID"] as? String {
                    return (ssid, bssid)
                }
            }
        }
    }
    return ("未知", "未知")
}

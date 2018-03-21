//
//  HTMLparser.swift
//  SrunKit
//
//  Created by Legolas.Invoker on 2018/3/20.
//  Copyright © 2018年 Legolas Invoker. All rights reserved.
//

import Foundation
import Kanna

/// 从HTML里解析出第一个匹配的节点
///
/// - Parameters:
///   - nodeName: 节点名称 如div input
///   - attributeTitle: 限定节点属性 如 class id
///   - attributeValue: 属性的具体值 如 button
///   - value: 需要的该节点的哪个其他属性，若为空则返回该节点的innerHTML
///   - html: html源
/// - Returns: 解析出的值,若解析失败，则返回nil
func getParsedValue(nodeName:String, attributeTitle:String, attributeValue:String, value:String?, html:String) -> String? {
    if let doc = try? HTML(html: html, encoding: .utf8) {
        let path = "//\(nodeName)[@\(attributeTitle)='\(attributeValue)']"
        print(path)
        for link in doc.xpath(path) {
            if let value = value {
                if let result = link["\(value)"] {
                    return result
                }
            } else {
                if let innerHTML = link.innerHTML {
                    return innerHTML
                }
            }
        }
    }
    return nil
}

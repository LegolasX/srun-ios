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
    return getParsedValueWithAddtion(nodeName: nodeName, attributeTitle: attributeTitle, attributeValue: attributeValue, value: value, html: html, addtion: nil)
}

/// 从HTML里解析出第一个匹配的节点
///
/// - Parameters:
///   - nodeName: 节点名称 如div input
///   - attributeTitle: 限定节点属性 如 class id
///   - attributeValue: 属性的具体值 如 button
///   - value: 需要的该节点的哪个其他属性，若为空则返回该节点的innerHTML
///   - html: html源
///   - addtion: 额外要加的内容
/// - Returns: 解析出的值,若解析失败，则返回nil
func getParsedValueWithAddtion(nodeName:String, attributeTitle:String, attributeValue:String, value:String?, html:String, addtion:String?) -> String? {
    let path = "//\(nodeName)[@\(attributeTitle)='\(attributeValue)'\(addtion ?? "")]"
//    print(path)
    return getParsedValueWith(path, from: html, for: value)
}

func getParsedValueWith(_ xpath:String, from html:String,for value:String?) -> String?{
    if let doc = try? HTML(html: html, encoding: .utf8) {
        for link in doc.xpath(xpath) {
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
    return nil;
}

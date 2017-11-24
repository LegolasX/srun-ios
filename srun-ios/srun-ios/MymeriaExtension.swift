//
//  MymeriaExtension.swift
//  srun-ios
//
//  Created by Legolas Invoker on 2017/9/7.
//  Copyright © 2017年 Legolas Invoker. All rights reserved.
//

import Foundation
import UIKit
extension UIImage
{
    func resizedImage(withSize newSize:CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        return newImage!
    }
    func kt_drawRectWithRoundedCorner(radius: CGFloat, _ sizetoFit: CGSize) -> UIImage {
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: sizetoFit)
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
        UIGraphicsGetCurrentContext()!.addPath(UIBezierPath(roundedRect: rect, byRoundingCorners: UIRectCorner.allCorners,
                                                            cornerRadii: CGSize(width: radius, height: radius)).cgPath)
        UIGraphicsGetCurrentContext()?.clip()
        
        self.draw(in: rect)
        UIGraphicsGetCurrentContext()!.drawPath(using: .fillStroke)
        let output = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return output!
    }
    
}
extension UIColor {
    func toImage() -> UIImage {
        let rect = CGRect(0,0,100,100)
        UIGraphicsBeginImageContext(rect.size);
        let context = UIGraphicsGetCurrentContext();
        context?.setFillColor(self.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return image!;
    }
}

extension CGSize {
    init(_ width:Int, _ height:Int)  {
        self.init(width : width, height : height)
    }
    init(_ width:CGFloat, _ height:CGFloat)  {
        self.init(width : width, height : height)
    }
    init(_ width:Double, _ height:Double)  {
        self.init(width : width, height : height)
    }
    
    
}
extension CGRect {
    init(_ x:Int, _ y:Int, _ width:Int, _ height:Int) {
        self.init(x: x, y: y, width: width, height: height)
    }
    init(_ x:CGFloat, _ y:CGFloat, _ width:CGFloat, _ height:CGFloat) {
        self.init(x: x, y: y, width: width, height: height)
    }
    init(_ x:Double, _ y:Double, _ width:Double, _ height:Double) {
        self.init(x: x, y: y, width: width, height: height)
    }
}

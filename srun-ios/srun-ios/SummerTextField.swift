//
//  SummerTextField.swift
//  srun-ios
//
//  Created by Legolas Invoker on 2017/9/7.
//  Copyright © 2017年 Legolas Invoker. All rights reserved.
//

import UIKit

class SummerTextField: UITextField {

    override func awakeFromNib() {
        textColor = UIColor.white
        layer.cornerRadius = 4
        layer.masksToBounds = true
        clipsToBounds = true
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.startPoint = CGPoint.init(x: 1, y: 0)
        gradientLayer.endPoint = CGPoint.init(x: 0, y: 0)
        gradientLayer.colors = [RGBCOLOR(r: 70, 75, 80).cgColor, UIColor.lrBlack.cgColor]
        layer.addSublayer(gradientLayer)
    }
    
    
    
    

}

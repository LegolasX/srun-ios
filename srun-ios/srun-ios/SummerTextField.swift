//
//  SummerTextField.swift
//  srun-ios
//
//  Created by Legolas Invoker on 2017/9/7.
//  Copyright © 2017年 Legolas Invoker. All rights reserved.
//

import UIKit

class SummerTextField: UITextField {

    let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func layoutSubviews() {
        layout()
    }
    
    func setup() {
        textColor = UIColor.white
        layer.cornerRadius = 4
        layer.masksToBounds = true
        clipsToBounds = true
//        setValue(UIColor.white, forKey: "_placeholderLabel.textColor")
//        let label = value(forKey: "_placeholderLabel") as! UILabel
        layout()
        gradientLayer.startPoint = CGPoint.init(x: 1, y: 0)
        gradientLayer.endPoint = CGPoint.init(x: 0, y: 0)
        gradientLayer.colors = [RGBCOLOR(r: 70, 75, 80).cgColor, UIColor.lrBlack.cgColor]
        layer.addSublayer(gradientLayer)
    }
    
    func layout() {
        gradientLayer.frame = bounds
    }
}

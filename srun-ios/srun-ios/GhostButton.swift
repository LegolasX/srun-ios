//
//  GhostButton.swift
//  srun-ios
//
//  Created by Legolas Invoker on 2017/9/5.
//  Copyright © 2017年 Legolas Invoker. All rights reserved.
//

import UIKit

class GhostButton: UIButton {

    let gradientLayer = CAGradientLayer()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    override func layoutSubviews() {
        layout()
        super.layoutSubviews()
    }
    
    func setup() {
        setTitleColor(UIColor.white, for: .normal)
        layer.cornerRadius = 4
        layer.masksToBounds = true
        clipsToBounds = true
        layer.addSublayer(gradientLayer)
        layout()
        gradientLayer.startPoint = CGPoint.init(x: 1, y: 0)
        gradientLayer.endPoint = CGPoint.init(x: 0, y: 0)
        gradientLayer.colors = [RGBCOLOR(r: 70, 75, 80).cgColor, UIColor.lrBlack.cgColor]
    }
    
    func layout() {
        gradientLayer.frame = bounds
    }
}

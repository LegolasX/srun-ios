//
//  GhostButton.swift
//  srun-ios
//
//  Created by Legolas Invoker on 2017/9/5.
//  Copyright © 2017年 Legolas Invoker. All rights reserved.
//

import UIKit

class GhostButton: UIButton {
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setTitleColor(UIColor.white, for: .normal)
//        layer.cornerRadius = 4
//        layer.masksToBounds = true
//        clipsToBounds = true
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.frame = bounds
//        gradientLayer.startPoint = CGPoint.init(x: 1, y: 0)
//        gradientLayer.endPoint = CGPoint.init(x: 0, y: 0)
//        gradientLayer.colors = [RGBCOLOR(r: 70, 75, 80).cgColor, UIColor.lrBlack.cgColor]
//        layer.addSublayer(gradientLayer)
//    }
//
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setTitleColor(UIColor.white, for: .normal)
        layer.cornerRadius = 4
        layer.masksToBounds = true
        clipsToBounds = true
        layout()
        layer.addSublayer(gradientLayer)
        backgroundColor = UIColor.brown
        
    }
//
//    convenience init() {
//        self.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
//    }
    
    let gradientLayer = CAGradientLayer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        setTitleColor(UIColor.white, for: .normal)
//        layer.cornerRadius = 4
//        layer.masksToBounds = true
//        clipsToBounds = true
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.frame = bounds
//        print(bounds)
//        gradientLayer.startPoint = CGPoint.init(x: 1, y: 0)
//        gradientLayer.endPoint = CGPoint.init(x: 0, y: 0)
//        gradientLayer.colors = [RGBCOLOR(r: 70, 75, 80).cgColor, UIColor.lrBlack.cgColor]
//        layer.addSublayer(gradientLayer)
//        backgroundColor = UIColor.brown
    }
    
    func layout() {
        gradientLayer.frame = bounds
        gradientLayer.startPoint = CGPoint.init(x: 1, y: 0)
        gradientLayer.endPoint = CGPoint.init(x: 0, y: 0)
        gradientLayer.colors = [RGBCOLOR(r: 70, 75, 80).cgColor, UIColor.lrBlack.cgColor]
    }
    
    override func layoutSubviews() {
        layout()
        super.layoutSubviews()
    }

}

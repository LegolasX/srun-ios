//
//  GhostButton.swift
//  srun-ios
//
//  Created by Legolas Invoker on 2017/9/5.
//  Copyright © 2017年 Legolas Invoker. All rights reserved.
//

import UIKit

class GhostButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    func setup() {
        setTitleColor(UIColor.white, for: .normal)
        layer.shadowOpacity = 0.8
        layer.shadowOffset = CGSize(width: 2, height: 3)
        layer.shadowColor = UIColor.lrBlack.cgColor
        backgroundColor = .clear
    }
}

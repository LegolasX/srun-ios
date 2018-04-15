//
//  SummerTextField.swift
//  srun-ios
//
//  Created by Legolas Invoker on 2017/9/7.
//  Copyright © 2017年 Legolas Invoker. All rights reserved.
//

import UIKit

class SummerTextField: UITextField {

    let lineView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }
    
    func defaultRect(original bounds:CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 5, y: bounds.origin.y, width: bounds.size.width, height: bounds.size.height)
    }
    
    //调整文本框的文本显示、占位符、编辑状态下的内边距
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return defaultRect(original:bounds)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return defaultRect(original:bounds)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return defaultRect(original:bounds)
    }
    
    func setup() {
        textColor = .white
        backgroundColor = .clear
        borderStyle = .none
        layer.shadowOpacity = 0.8
        layer.shadowOffset = CGSize(width: 2, height: 3)
        layer.shadowColor = UIColor.lrBlack.cgColor
        layer.masksToBounds = false
        keyboardAppearance = .dark
        lineView.backgroundColor = .white
        addSubview(lineView)
    }
    
    func layout() {
        lineView.frame = CGRect(x: bounds.origin.x, y: bounds.origin.y + bounds.size.height-1, width: bounds.size.width, height: 1)
    }
}

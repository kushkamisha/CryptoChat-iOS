//
//  InputBox.swift
//  crypto-chat
//
//  Created by Kushka Misha on 2/4/20.
//  Copyright © 2020 Misha Kushka. All rights reserved.
//

import UIKit

class InputBox: UIView {
    //initWithFrame to init view from code
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    //initWithCode to init view from xib or storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    //common func to init our view
    private func setupView() {
        backgroundColor = UIColor(red: 122, green: 140, blue: 255, alpha: 0)
        
        cornerRadius = 10
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 1
    }
}

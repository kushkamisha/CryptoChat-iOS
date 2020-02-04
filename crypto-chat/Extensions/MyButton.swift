//
//  MyButton.swift
//  crypto-chat
//
//  Created by Kushka Misha on 2/4/20.
//  Copyright © 2020 Misha Kushka. All rights reserved.
//

import Foundation
import UIKit

class MyButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = UIColor.white
        cornerRadius = 10
    }
}

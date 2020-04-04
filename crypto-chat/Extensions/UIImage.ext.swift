//
//  UIImage.ext.swift
//  crypto-chat
//
//  Created by Kushka Misha on 4/4/20.
//  Copyright © 2020 Misha Kushka. All rights reserved.
//

import UIKit

extension UIImage {

    func isEqualToImage(image: UIImage) -> Bool {
        let data1: NSData = self.pngData()! as NSData
        let data2: NSData = image.pngData()! as NSData
        return data1.isEqual(data2)
    }

}

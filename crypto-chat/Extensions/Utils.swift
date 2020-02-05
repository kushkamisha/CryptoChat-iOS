//
//  Utils.swift
//  crypto-chat
//
//  Created by Kushka Misha on 2/5/20.
//  Copyright © 2020 Misha Kushka. All rights reserved.
//

import Foundation
import CryptoKit

extension Digest {
    var bytes: [UInt8] { Array(makeIterator()) }
    var data: Data { Data(bytes) }

    var hexStr: String {
        bytes.map { String(format: "%02X", $0) }.joined().lowercased()
    }
}

//
//  Chat.swift
//  crypto-chat
//
//  Created by Kushka Misha on 2/20/20.
//  Copyright © 2020 Misha Kushka. All rights reserved.
//

import Foundation
import Alamofire

class Chat {
    func loadChats() {
            let params: [String: String] = [
                "userId": String(1),
            ]
            
            AF.request("http://localhost:3000/userSessionCheck",
                       method: .post,
                       parameters: params,
                       encoder: JSONParameterEncoder.default).responseJSON { response in
                switch response.result {
                    case .success(let data):
                        print(response)
                        let socket = Socket.init(userId: 1)
                        print("\nnext line")
    //                    socket.socket.on
                    case .failure(let error):
                        print(error.localizedDescription)
                }
            }
        }
}

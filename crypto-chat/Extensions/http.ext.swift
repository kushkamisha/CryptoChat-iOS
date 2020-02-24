//
//  http.ext.swift
//  crypto-chat
//
//  Created by Kushka Misha on 2/24/20.
//  Copyright © 2020 Misha Kushka. All rights reserved.
//

import Alamofire

extension ChatViewController {
    func getMessages(friendId: String) -> Future<[Dictionary<String, String>]> {
        return Future { completion in
            let params: [String: String] = [
                "userId": self.userId,
                "toUserId": friendId
            ]
            AF.request("http://localhost:3000/getMessages",
                       method: .post,
                       parameters: params,
                       encoder: JSONParameterEncoder.default).responseJSON { response in
                switch response.result {
                    case .success(let data):
                        let messages = (data as! NSDictionary)["messages"] as! NSArray
                        var msgList = [[String: String]]()
                        for msg in messages {
                            let m = msg as! NSDictionary
                            var tmp = [String: String]()
                            
                            tmp["msgId"] = "\(m["id"] as! Int)"
                            tmp["fromUserId"] = m["fromUserId"] as? String
                            tmp["toUserId"] = m["toUserId"] as? String
                            tmp["message"] = m["message"] as? String
                            
                            msgList.append(tmp)
                        }
                        
                        completion(.success(msgList))
                        break
                    case .failure(let error):
                        print(error.localizedDescription)
                }
            }
        }
    }
}

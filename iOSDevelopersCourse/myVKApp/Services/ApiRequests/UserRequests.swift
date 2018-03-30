//
//  UserRequests.swift
//  myVKApp
//
//  Created by Natalya on 30/03/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import Alamofire
import SwiftyJSON

class UserRequests {
    
    static let baseUrl = "https://api.vk.com"
    static let path = "/method"
    
    static func getUserById(userId: String, accessToken: String, requestUserId: String, main: Bool) {
        let pathMethod = "/users.get"
        let url = baseUrl + path + pathMethod
        let parameters: Parameters = [
            "user_id":userId,
            "access_token":accessToken,
            "user_ids":requestUserId,
            "fields":"uid, first_name, last_name, photo_100",
            "v":"5.73"
        ]
        
        Alamofire.request(url, method: .get, parameters: parameters).validate().responseJSON(queue: DispatchQueue.global(qos: .utility)) { response in
            switch response.result {
            case .success(let value):
                if main {
                    let users = JSON(value)["response"].compactMap({ User(json: $0.1) })
                    for user in users {
                        RealmUserSaver.createUser(user: user)
                    }
                } else {
                    let users = JSON(value)["response"].compactMap({ Friend(json: $0.1) })
                    for user in users {
                        RealmFriendsSaver.saveSingleFriend(friends: user, userId: userId)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

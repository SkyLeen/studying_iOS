//
//  UserRequests.swift
//  myVKApp
//
//  Created by Natalya on 30/03/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import Alamofire
import SwiftyJSON
import FirebaseDatabase

enum Attributes {
    case mainUser
    case fromDialogs
    case newFriend
}

class UserRequests {
    
    static let dbLink = Database.database().reference().child("VKApp/Users")
    
    static let baseUrl = "https://api.vk.com"
    static let path = "/method"
    
    static func getUserById(userId: String, accessToken: String, requestUserId: String, attribute: Attributes) {
        let pathMethod = "/users.get"
        let url = baseUrl + path + pathMethod
        let parameters: Parameters = [
            "access_token":accessToken,
            "user_ids":requestUserId,
            "fields":"uid, first_name, last_name, photo_100",
            "v":"5.73"
        ]
        
        Alamofire.request(url, method: .get, parameters: parameters).validate().responseJSON(queue: DispatchQueue.global(qos: .utility)) { response in
            switch response.result {
            case .success(let value):
                switch attribute {
                case .mainUser:
                    let users = JSON(value)["response"].compactMap({ User(json: $0.1) })
                    for user in users {
                        RealmUserSaver.createUser(user: user)
                        
                        let data = user.makeAny
                        dbLink.child(user.idUser).setValue(data)
                    }
                    
                case .fromDialogs:
                    let users = JSON(value)["response"].compactMap({ Friend(json: $0.1) })
                    for user in users {
                        RealmFriendsSaver.saveFriend(friends: user)
                    }
                case .newFriend:
                    let users = JSON(value)["response"].compactMap({ Friend(json: $0.1, userId: userId) })
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

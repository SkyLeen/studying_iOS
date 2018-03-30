//
//  UsersRequests.swift
//  myVKApp
//
//  Created by Natalya on 13/03/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import Alamofire
import SwiftyJSON

class FriendsRequests {
    
    static let baseUrl = "https://api.vk.com"
    static let path = "/method"
    
   static func getFriendsList(userId: String, accessToken: String) {
        let pathMethod = "/friends.get"
        let url = baseUrl + path + pathMethod
        let parameters: Parameters = [
            "user_id":userId,
            "access_token":accessToken,
            "order":"name",
            "fields": "uid, first_name, last_name, photo_100",
            "v":"5.73"
        ]
        
    Alamofire.request(url, method: .get, parameters: parameters).validate().responseJSON(queue: DispatchQueue.global(qos: .utility)) { response in
            switch response.result {
            case .success(let value):
                let users = JSON(value)["response"]["items"].compactMap({ Friend(json: $0.1) })
                RealmFriendsSaver.saveFriendsData(friends: users, userId: userId)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    static func getFriendPhotos(userId: String, accessToken: String, friendId: Int) {
        let pathMethod = "/photos.getAll"
        let url = baseUrl + path + pathMethod
        let parameters: Parameters = [
            "user_id":userId,
            "access_token":accessToken,
            "owner_id":friendId,
            "skip_hidden":"1",
            "v":"5.73"
        ]
        
        Alamofire.request(url, method: .get, parameters: parameters).validate().responseJSON(queue: DispatchQueue.global(qos: .utility)) { response in
            switch response.result {
            case .success(let value):
                let photos = JSON(value)["response"]["items"].compactMap({ Photos(json: $0.1) })
                RealmFriendsSaver.saveFriendsPhotos(photos: photos, friendId: friendId)
            case .failure(let error):
                print(error)
            }
        }
    }
}

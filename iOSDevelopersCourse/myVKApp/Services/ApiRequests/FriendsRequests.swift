//
//  UsersRequests.swift
//  myVKApp
//
//  Created by Natalya on 13/03/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import Alamofire
import SwiftyJSON
import SwiftKeychainWrapper

class FriendsRequests {
    
    static private let accessToken = KeychainWrapper.standard.string(forKey: "accessToken")
    static private let userId =  KeychainWrapper.standard.string(forKey: "userId")
    
    static let baseUrl = "https://api.vk.com"
    static let path = "/method"
    
   static func getFriendsList(closure: @escaping ([Friend])->()) {
        let pathMethod = "/friends.get"
        let url = baseUrl + path + pathMethod
        let parameters: Parameters = [
            "user_id":userId!,
            "access_token":accessToken!,
            "order":"name",
            "fields": "uid, first_name, last_name, photo_100",
            "v":"5.73"
        ]
        
    Alamofire.request(url, method: .get, parameters: parameters).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let users = JSON(value)["response"]["items"].compactMap({ Friend(json: $0.1, userId: userId!) })
                RealmFriendsSaver.saveFriendsData(friends: users, userId: userId!)
                closure(users)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    static func getFriendPhotos(friendId: String) {
        let pathMethod = "/photos.getAll"
        let url = baseUrl + path + pathMethod
        let parameters: Parameters = [
            "user_id":userId!,
            "access_token":accessToken!,
            "owner_id":friendId,
            "skip_hidden":"1",
            "v":"5.73"
        ]
        
        Alamofire.request(url, method: .get, parameters: parameters).validate().responseJSON(queue: DispatchQueue.global(qos: .utility)) { response in
            switch response.result {
            case .success(let value):
                let photos = JSON(value)["response"]["items"].compactMap({ Photos(json: $0.1) })
                RealmFriendsSaver.saveFriendsPhotos(photos: photos, friendId: friendId, userId: userId!)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    static func getIncomingFriendsRequest(complition: @escaping (Int) -> ()) {
        let pathMethod = "/friends.getRequests"
        let url = baseUrl + path + pathMethod
        let parameters: Parameters = [
            "access_token":accessToken!,
            "out":0,
            "need_mutual":1,
            "v":"5.73"
        ]
        
        Alamofire.request(url, method: .get, parameters: parameters).validate().responseJSON(queue: DispatchQueue.global(qos: .utility)) { response in
            switch response.result {
            case .success(let value):
                let requests = JSON(value)["response"]["items"]
                RealmDeleter.removeRequests()
                for request in requests {
                    let user = request.1["user_id"].stringValue
                    UserRequests.getUserById(userId: userId!, accessToken: accessToken!, requestUserId: user, attribute: .requests)
                }
                complition(requests.count)
            case .failure(let error):
                print(error)
            }
        }
    }
}

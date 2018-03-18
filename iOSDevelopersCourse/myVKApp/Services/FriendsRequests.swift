//
//  UsersRequests.swift
//  myVKApp
//
//  Created by Natalya on 13/03/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift

class FriendsRequests {
    
    let baseUrl = "https://api.vk.com"
    let path = "/method"
    
    func getFriendsList(userId: String, accessToken: String, completion: @escaping () -> ()) {
        let pathMethod = "/friends.get"
        let url = baseUrl + path + pathMethod
        let parameters: Parameters = [
            "user_id":userId,
            "access_token":accessToken,
            "order":"name",
            "fields": "uid, first_name, last_name, photo_100",
            "v":"5.73"
        ]
        
        Alamofire.request(url, method: .get, parameters: parameters).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let users = JSON(value)["response"]["items"].flatMap({ Friend(json: $0.1) })
                self.loadFriendsData(friends: users, userId: userId, accessToken: accessToken)
                completion()
            case .failure(let error):
                print(error)
                completion()
            }
        }
    }
    
    func getFriendPhotos(userId: String, accessToken: String, friendId: Int, completion: @escaping () -> ()) {
        let pathMethod = "/photos.get"
        let url = baseUrl + path + pathMethod
        let parameters: Parameters = [
            "user_id":userId,
            "access_token":accessToken,
            "owner_id":friendId,
            "album_id":"wall",
            "rev":"1",
            "v":"5.73"
        ]
        
        Alamofire.request(url, method: .get, parameters: parameters).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let photos = JSON(value)["response"]["items"].flatMap({ Photos(json: $0.1) })
                self.loadFriendsPhotos(photos: photos, friendId: friendId)
                completion()
            case .failure(let error):
                print(error)
                completion()
            }
        }
    }
    
    private func loadFriendsData(friends: [Friend], userId: String, accessToken: String) {
        do {
            let realm = try Realm()
            let user = realm.object(ofType: User.self, forPrimaryKey: userId)
            let oldFriends = realm.objects(Friend.self)
            try realm.write {
                realm.delete(oldFriends)
                for friend in friends {
                    user?.friends.append(friend)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func loadFriendsPhotos (photos: [Photos], friendId: Int) {
        do {
            let realm = try Realm()
            let friend = realm.object(ofType: Friend.self, forPrimaryKey: friendId)
            let oldPhotos = realm.objects(Photos.self).filter("idFriend == %@", friendId)
            try realm.write {
                realm.delete(oldPhotos)
                for photo in photos {
                    friend?.photos.append(photo)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

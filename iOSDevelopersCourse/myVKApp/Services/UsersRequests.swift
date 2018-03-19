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

class UsersRequests {
    
    let baseUrl = "https://api.vk.com"
    let path = "/method"
    
    func getFrendsList(userId: String, accessToken: String, completion: @escaping ([User]) -> ()) {
        let pathMethod = "/friends.get"
        let url = baseUrl + path + pathMethod
        let parameters: Parameters = [
            "user_id":userId,
            "access_token":accessToken,
            "order":"name",
            "fields": "uid, first_name, last_name, photo_100",
            "v":"5.73"
        ]
        
        Alamofire.request(url, method: .get, parameters: parameters).validate().responseJSON { [weak self] response in
            switch response.result {
            case .success(let value):
                let users = JSON(value)["response"]["items"].flatMap({ User(json: $0.1) })
                self?.saveUserData(users: users)
                completion(users)
            case .failure(let error):
                print(error)
                completion([])
            }
        }
    }
    
    func getFriendPhotos(userId: String, accessToken: String, friendId: Int, completion: @escaping ([Photos]) -> ()) {
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
        
        Alamofire.request(url, method: .get, parameters: parameters).validate().responseJSON { [weak self] response in
            switch response.result {
            case .success(let value):
                let photos = JSON(value)["response"]["items"].flatMap({ Photos(json: $0.1) })
                self?.saveUserData(photos: photos)
                completion(photos)
            case .failure(let error):
                print(error)
                completion([])
            }
        }
    }
    
    private func saveUserData(users: [User]) {
        do {
            let realm = try Realm()
            realm.beginWrite()
            realm.add(users)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
    
    private func saveUserData(photos: [Photos]) {
        do {
            let realm = try Realm()
            realm.beginWrite()
            realm.add(photos)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
}

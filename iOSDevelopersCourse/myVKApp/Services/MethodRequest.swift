//
//  MethodRequest.swift
//  myVKApp
//
//  Created by Natalya on 03/03/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class MethodRequest {
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
        
        Alamofire.request(url, method: .get, parameters: parameters).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let users = JSON(value)["response"]["items"].flatMap({ User(json: $0.1) })
                completion(users)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getPhotos(userId: String, accessToken: String, friendId: String) {
        let pathMethod = "/photos.get"
        let url = baseUrl + path + pathMethod
        let parameters: Parameters = [
            "user_id":userId,
            "access_token":accessToken,
            "owner_id":friendId,
            "album_id":"profile",
            "rev":"1",
            "v":"5.73"
        ]
        
        Alamofire.request(url, method: .get, parameters: parameters).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("Photos: \(json)")
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getUserGroups(userId: String, accessToken: String) {
        let pathMethod = "/groups.get"
        let url = baseUrl + path + pathMethod
        let parameters: Parameters = [
            "user_id":userId,
            "access_token":accessToken,
            "extended":"1",
            "fields":"members_count",
            "v":"5.73"
        ]
        
        Alamofire.request(url, method: .get, parameters: parameters).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("UserGroups: \(json)")
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getAllGroups(accessToken: String) {
        let pathMethod = "/groups.getCatalog"
        let url = baseUrl + path + pathMethod
        let parameters: Parameters = [
            "access_token":accessToken,
            "extended":"1",
            "fields":"members_count",
            "v":"5.73"
        ]
        
        Alamofire.request(url, method: .get, parameters: parameters).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("AllGroups: \(json)")
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getGroupsByName(accessToken: String, groupName: String) {
        let pathMethod = "/groups.search"
        let url = baseUrl + path + pathMethod
        let parameters: Parameters = [
            "q":groupName,
            "access_token":accessToken,
            "fields":"members_count",
            "v":"5.73"
        ]
        
        Alamofire.request(url, method: .get, parameters: parameters).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("SearchGroups: \(json)")
            case .failure(let error):
                print(error)
            }
        }
    }
}

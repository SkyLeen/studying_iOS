//
//  MethodRequest.swift
//  myVKApp
//
//  Created by Natalya on 03/03/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import Alamofire
import SwiftyJSON

class GroupsRequests {

    static let baseUrl = "https://api.vk.com"
    static let path = "/method"
    
    static func getUserGroups(userId: String, accessToken: String) {
        let pathMethod = "/groups.get"
        let url = baseUrl + path + pathMethod
        let parameters: Parameters = [
            "user_id":userId,
            "access_token":accessToken,
            "extended":1,
            "fields":"members_count",
            "v":"5.73"
        ]
        
        Alamofire.request(url, method: .get, parameters: parameters).validate().responseJSON {  response in
            switch response.result {
            case .success(let value):
                let groups = JSON(value)["response"]["items"].compactMap({ Group(json: $0.1, userId: userId) })
                RealmGroupsSaver.saveUserGroups(groups: groups, userId: userId)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    static func getAllGroups(accessToken: String) {
        let pathMethod = "/groups.getCatalog"
        let url = baseUrl + path + pathMethod
        let parameters: Parameters = [
            "access_token":accessToken,
            "extended":1,
            "fields":"members_count",
            "v":"5.73"
        ]
        
        Alamofire.request(url, method: .get, parameters: parameters).validate().responseJSON(queue: DispatchQueue.global(qos: .utility)) { response in
            switch response.result {
            case .success(let value):
                let groups = JSON(value)["response"]["items"].compactMap({ Group(json: $0.1) })
                RealmGroupsSaver.saveAllGroups(groups: groups)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    static func joinGroup (accessToken: String, idGroup: String) {
        let pathMethod = "/groups.join"
        let url = baseUrl + path + pathMethod
        let parameters: Parameters = [
            "group_id":idGroup,
            "access_token":accessToken,
            "v":"5.73"
        ]
        
        Alamofire.request(url, method: .get, parameters: parameters).validate().responseJSON(queue: DispatchQueue.global(qos: .utility)) { response in
            switch response.result {
            case .success(let value):
                print(JSON(value))
            case .failure(let error):
                print(error)
            }
        }
    }
    
    static func leaveGroup (accessToken: String, idGroup: String) {
        let pathMethod = "/groups.leave"
        let url = baseUrl + path + pathMethod
        let parameters: Parameters = [
            "group_id":idGroup,
            "access_token":accessToken,
            "v":"5.73"
        ]
        
        Alamofire.request(url, method: .get, parameters: parameters).validate().responseJSON(queue: DispatchQueue.global(qos: .utility)) { response in }
    }
}

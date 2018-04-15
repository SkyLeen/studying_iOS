//
//  MethodRequest.swift
//  myVKApp
//
//  Created by Natalya on 03/03/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import Alamofire
import SwiftyJSON
import SwiftKeychainWrapper
import FirebaseDatabase

class GroupsRequests {

    static private let accessToken = KeychainWrapper.standard.string(forKey: "accessToken")
    static private let userId =  KeychainWrapper.standard.string(forKey: "userId")
    
    static let dbLink = Database.database().reference().child("VKApp/Users/\(userId!)")
    
    static let baseUrl = "https://api.vk.com"
    static let path = "/method"
    
    static func getUserGroups() {
        let pathMethod = "/groups.get"
        let url = baseUrl + path + pathMethod
        let parameters: Parameters = [
            "user_id":userId!,
            "access_token":accessToken!,
            "extended":1,
            "fields":"members_count",
            "v":"5.73"
        ]
        
        Alamofire.request(url, method: .get, parameters: parameters).validate().responseJSON {  response in
            switch response.result {
            case .success(let value):
                let groups = JSON(value)["response"]["items"].compactMap({ Group(json: $0.1, userId: userId!) })
                RealmGroupsSaver.saveUserGroups(groups: groups)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    static func getAllGroups() {
        let pathMethod = "/groups.getCatalog"
        let url = baseUrl + path + pathMethod
        let parameters: Parameters = [
            "access_token":accessToken!,
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
    
    static func joinGroup (idGroup: String) {
        let pathMethod = "/groups.join"
        let url = baseUrl + path + pathMethod
        let parameters: Parameters = [
            "group_id":idGroup,
            "access_token":accessToken!,
            "v":"5.73"
        ]
        
        Alamofire.request(url, method: .get, parameters: parameters).validate().responseJSON(queue: DispatchQueue.global(qos: .utility)) { response in
            switch response.result {
            case .success(let value):
                let _ = dbLink.observe(.value) { snapshot in
                    let data = RealmLoader.loadData(object: Group()).filter("idGroup == %@", "\(idGroup)")
                    let group = data[0].makeAny
                    dbLink.child("groups/\(data[0].idGroup)").setValue(group)
                }
                
                print(JSON(value))
            case .failure(let error):
                print(error)
            }
        }
    }
    
    static func leaveGroup (idGroup: String) {
        let pathMethod = "/groups.leave"
        let url = baseUrl + path + pathMethod
        let parameters: Parameters = [
            "group_id":idGroup,
            "access_token":accessToken!,
            "v":"5.73"
        ]
        
        Alamofire.request(url, method: .get, parameters: parameters).validate().responseJSON(queue: DispatchQueue.global(qos: .utility)) { response in }
    }
    
    static func getGroupById(idGroup: String) {
        let pathMethod = "/groups.getById"
        let url = baseUrl + path + pathMethod
        let parameters: Parameters = [
            "access_token":accessToken!,
            "group_ids":idGroup,
            "fields":"members_count",
            "v":"5.73"
        ]
        
        Alamofire.request(url, method: .get, parameters: parameters).validate().responseJSON {  response in
            switch response.result {
            case .success(let value):
                let groups = JSON(value)["response"].compactMap({ Group(json: $0.1) })
                RealmGroupsSaver.saveAllGroups(groups: groups)
            case .failure(let error):
                print(error)
            }
        }
    }
}

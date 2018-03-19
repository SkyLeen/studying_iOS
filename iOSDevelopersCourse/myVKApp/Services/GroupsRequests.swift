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
import RealmSwift

class GroupsRequests {

    let baseUrl = "https://api.vk.com"
    let path = "/method"
    
    func getUserGroups(userId: String, accessToken: String, completion: @escaping ([Group]) -> ()) {
        let pathMethod = "/groups.get"
        let url = baseUrl + path + pathMethod
        let parameters: Parameters = [
            "user_id":userId,
            "access_token":accessToken,
            "extended":1,
            "fields":"members_count",
            "v":"5.73"
        ]
        
        Alamofire.request(url, method: .get, parameters: parameters).validate().responseJSON { [weak self] response in
            switch response.result {
            case .success(let value):
                let groups = JSON(value)["response"]["items"].flatMap({ Group(json: $0.1) })
                self?.saveUserData(groups: groups)
                completion(groups)
            case .failure(let error):
                print(error)
                completion([])
            }
        }
    }
    
    func getAllGroups(accessToken: String, completion: @escaping ([Group]) -> ()) {
        let pathMethod = "/groups.getCatalog"
        let url = baseUrl + path + pathMethod
        let parameters: Parameters = [
            "access_token":accessToken,
            "extended":1,
            "fields":"members_count",
            "v":"5.73"
        ]
        
        Alamofire.request(url, method: .get, parameters: parameters).validate().responseJSON { [weak self] response in
            switch response.result {
            case .success(let value):
                let groups = JSON(value)["response"]["items"].flatMap({ Group(json: $0.1) })
                self?.saveUserData(groups: groups)
                completion(groups)
            case .failure(let error):
                print(error)
                completion([])
            }
        }
    }
    
    func getGroupsSearch(accessToken: String, searchText: String, completion: @escaping ([Group]) -> ()) {
        let pathMethod = "/groups.search"
        let url = baseUrl + path + pathMethod
        let parameters: Parameters = [
            "q":searchText.lowercased(),
            "access_token":accessToken,
            "sort":2,
            "fields":"members_count",
            "v":"5.73"
        ]
        
        Alamofire.request(url, method: .get, parameters: parameters).validate().responseJSON { [weak self] response in
            switch response.result {
            case .success(let value):
                let groups = JSON(value)["response"]["items"].flatMap({ Group(json: $0.1) })
                self?.saveUserData(groups: groups)
                completion(groups)
            case .failure(let error):
                print(error)
                completion([])
            }
        }
    }
    
    func joinGroup (accessToken: String, idGroup: Int, completion: @escaping () -> ()) {
        let pathMethod = "/groups.join"
        let url = baseUrl + path + pathMethod
        let parameters: Parameters = [
            "group_id":idGroup,
            "access_token":accessToken,
            "v":"5.73"
        ]
        
        Alamofire.request(url, method: .get, parameters: parameters).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                print(JSON(value))
                completion()
            case .failure(let error):
                print(error)
                completion()
            }
        }
    }
    
    func leaveGroup (accessToken: String, idGroup: Int,completion: @escaping () -> ()) {
        let pathMethod = "/groups.leave"
        let url = baseUrl + path + pathMethod
        let parameters: Parameters = [
            "group_id":idGroup,
            "access_token":accessToken,
            "v":"5.73"
        ]
        
        Alamofire.request(url, method: .get, parameters: parameters).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                print(JSON(value))
                completion()
            case .failure(let error):
                print(error)
                completion()
            }
        }
    }
    
    private func saveUserData(groups: [Group]) {
        do {
            let realm = try Realm()
            realm.beginWrite()
            realm.add(groups)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
}

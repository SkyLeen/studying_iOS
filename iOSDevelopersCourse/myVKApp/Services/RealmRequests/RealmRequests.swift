//
//  RealmRequests.swift
//  myVKApp
//
//  Created by Natalya on 30/03/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import RealmSwift
import SwiftKeychainWrapper

class RealmRequests {
    
    static private let accessToken = KeychainWrapper.standard.string(forKey: "accessToken")
    static private let userId =  KeychainWrapper.standard.string(forKey: "userId")
    
    static func getUserGroups() -> Results<Group> {
        var result: Results<Group>!
        do {
            let realm = try Realm()
            let user = realm.object(ofType: User.self, forPrimaryKey: userId)
            //result = user?.groups.filter("idGroup != ''").sorted(byKeyPath: "nameGroup")
            result = user?.groups.sorted(byKeyPath: "nameGroup")
            } catch {
            print(error.localizedDescription)
        }
        return result
    }
    
    static func getFriendData(friend: String) -> (name: String, photoUrl: String?)? {
        guard let realm = try? Realm() else { return nil }
        
        let friend = realm.objects(Friend.self).filter("idFriend == %@", friend)
        if !friend.isEmpty {
            let name = friend[0].name
            let photoUrl = friend[0].photoUrl
            
            return (name: name, photoUrl: photoUrl)
        } else { return nil }
    }
    
    static func getGroupData(group: String) -> (name: String, photoUrl: String?)? {
        guard let realm = try? Realm() else { return nil }
        
        let group = realm.objects(Group.self).filter("idGroup == %@", group)
        if !group.isEmpty {
            let name = group[0].nameGroup
            let photoUrl = group[0].photoGroupUrl
            
            return (name: name, photoUrl: photoUrl)
        } else { return nil }
    }
}

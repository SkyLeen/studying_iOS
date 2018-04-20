//
//  RealmGroupsSaver.swift
//  myVKApp
//
//  Created by Natalya on 22/03/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import RealmSwift
import SwiftKeychainWrapper

class RealmGroupsSaver {
    
    static private let accessToken = KeychainWrapper.standard.string(forKey: "accessToken")
    static private let userId =  KeychainWrapper.standard.string(forKey: "userId")
    
    static func saveUserGroups(groups: [Group]) {
        do {
            let realm = try Realm()
            let user = realm.object(ofType: User.self, forPrimaryKey: userId)
           
            try realm.write {
                if  let oldGroups = user?.groups.filter("idGroup != ''"), !oldGroups.isEmpty { realm.delete(oldGroups) }
                user?.groups.append(objectsIn: groups)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    static func saveNewGroup(group: Group) {
        do {
            let realm = try Realm()
            let user = realm.object(ofType: User.self, forPrimaryKey: userId)
            try realm.write {
                user?.groups.append(group)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    static func saveAllGroups(groups: [Group]) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(groups,update: true)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

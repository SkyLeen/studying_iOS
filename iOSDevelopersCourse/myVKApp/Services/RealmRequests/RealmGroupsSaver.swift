//
//  RealmGroupsSaver.swift
//  myVKApp
//
//  Created by Natalya on 22/03/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import RealmSwift

class RealmGroupsSaver {
    
    static func saveUserGroups(groups: [Group], userId: String) {
        do {
            let realm = try Realm()
            let user = realm.object(ofType: User.self, forPrimaryKey: userId)
            let oldGroups = realm.objects(Group.self).filter("userId == %@", userId)
            try realm.write {
                realm.delete(oldGroups)
                user?.groups.append(objectsIn: groups)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    static func saveNewGroup(group: Group, userId: String) {
        do {
            let realm = try Realm()
            let user = realm.object(ofType: User.self, forPrimaryKey: userId)
            try realm.write {
                group.userId = userId
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

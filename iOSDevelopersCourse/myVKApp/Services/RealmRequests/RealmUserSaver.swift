//
//  RealmUserSaver.swift
//  myVKApp
//
//  Created by Natalya on 22/03/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import RealmSwift

class RealmUserSaver {
    
    static func createUser(user: User) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(user, update: true)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

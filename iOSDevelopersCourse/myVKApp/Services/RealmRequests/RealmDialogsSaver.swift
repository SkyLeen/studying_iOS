//
//  RealmDialogsSaver.swift
//  myVKApp
//
//  Created by Natalya on 28/03/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import RealmSwift

class RealmDialogSaver {

    static func saveUserDialogs(dialog: Dialog, userId: String) {
        do {
            let realm = try Realm()
            let user = realm.object(ofType: User.self, forPrimaryKey: userId)
            
            try realm.write {
                user?.dialogs.append(dialog)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    static func saveMessages(messages: [Message]) {
        do {
            let realm = try Realm()
            
            try realm.write {
                realm.add(messages, update: true)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

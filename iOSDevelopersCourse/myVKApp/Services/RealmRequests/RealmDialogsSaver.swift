//
//  RealmDialogsSaver.swift
//  myVKApp
//
//  Created by Natalya on 28/03/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import RealmSwift

class RealmDialogSaver {
    
    private static let config = setConfiguration()
    
    private static func setConfiguration() -> Realm.Configuration {
        var configuration = Realm.Configuration()
        configuration.deleteRealmIfMigrationNeeded = true
        
        return configuration
    }
    
    static func saveUserNews(dialog: Dialog, userId: String) {
        do {
            let realm = try Realm(configuration: config)
            let user = realm.object(ofType: User.self, forPrimaryKey: userId)
            let oldDialog = realm.objects(Dialog.self).filter("id == %@", dialog.id)
            let friend = realm.object(ofType: Friend.self, forPrimaryKey: dialog.friendId)
            
            dialog.friendName = friend?.name
            dialog.friendPhotoUrl = friend?.photoUrl
            
            try realm.write {
                realm.delete(oldDialog)
                user?.dialogs.append(dialog)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

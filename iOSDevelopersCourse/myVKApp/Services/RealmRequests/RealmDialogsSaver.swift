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
            
            let friendId = dialog.friendId
            
            if friendId > 0 {
                let friend = realm.object(ofType: Friend.self, forPrimaryKey: friendId)
                dialog.friendName = friend?.name
                dialog.friendPhotoUrl = friend?.photoUrl
            } else {
                let friend = realm.object(ofType: Group.self, forPrimaryKey: "\(friendId)\(userId)")
                dialog.friendName = friend?.nameGroup
                dialog.friendPhotoUrl = friend?.photoGroupUrl
            }
            
            try realm.write {
                user?.dialogs.append(dialog)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

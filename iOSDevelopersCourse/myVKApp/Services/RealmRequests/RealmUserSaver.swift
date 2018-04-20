//
//  RealmUserSaver.swift
//  myVKApp
//
//  Created by Natalya on 22/03/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import RealmSwift

class RealmUserSaver {
    
    private static let config = setConfiguration()
    
    private static func setConfiguration() -> Realm.Configuration {
        var configuration = Realm.Configuration()
        configuration.deleteRealmIfMigrationNeeded = true
        
        return configuration
    }
    
    static func createUser(user: User) {
        
        do {
            let realm = try Realm(configuration: config)
            try realm.write {
                realm.add(user, update: true)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

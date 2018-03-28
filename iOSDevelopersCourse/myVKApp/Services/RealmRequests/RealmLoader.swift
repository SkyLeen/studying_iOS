//
//  RealmLoader.swift
//  myVKApp
//
//  Created by Natalya on 20/03/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import RealmSwift

class RealmLoader {
    
    private static let config = setConfiguration()
    
    private static func setConfiguration() -> Realm.Configuration {
        var configuration = Realm.Configuration()
        configuration.deleteRealmIfMigrationNeeded = true
        
        return configuration
    }
    
    static func loadData<T: Object> (object: T) -> Results<T> {
        var result: Results<T>?
        do {
            let realm = try Realm(configuration: config)
            result = realm.objects(T.self)
        } catch {
            print(error.localizedDescription)
        }
        return result!
    }
}

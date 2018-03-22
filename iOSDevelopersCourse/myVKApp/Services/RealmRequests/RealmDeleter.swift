//
//  RealmDeleter.swift
//  myVKApp
//
//  Created by Natalya on 22/03/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import RealmSwift

class Deleter {
    
    static func deleteData<T: Object>(object: T){
        do {
            let realm = try Realm()
            try realm.write {
                realm.delete(object)
            }
            
        } catch {
            print(error.localizedDescription)
        }
    }
}

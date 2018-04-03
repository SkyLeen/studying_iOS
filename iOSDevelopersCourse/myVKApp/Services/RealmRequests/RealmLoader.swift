//
//  RealmLoader.swift
//  myVKApp
//
//  Created by Natalya on 20/03/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import RealmSwift

class RealmLoader {

    static func loadData<T: Object> (object: T) -> Results<T> {
        var result: Results<T>?
        do {
            let realm = try Realm()
            result = realm.objects(T.self)
        } catch {
            print(error.localizedDescription)
        }
        return result!
    }
}

//
//  RealmNewsSaver.swift
//  myVKApp
//
//  Created by Natalya on 25/03/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import RealmSwift

class RealmNewsSaver {

    static func saveUserNews(news: [News], userId: String) {
        do {
            let realm = try Realm()
            let user = realm.object(ofType: User.self, forPrimaryKey: userId)
            let oldNews = realm.objects(News.self)
            try realm.write {
                realm.delete(oldNews)
                user?.newsfeed.append(objectsIn: news)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

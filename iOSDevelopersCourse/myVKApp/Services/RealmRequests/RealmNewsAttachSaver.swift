//
//  RealmNewsAttachSaver.swift
//  myVKApp
//
//  Created by Natalya on 28/03/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import RealmSwift

class RealmNewsAttachSaver {
    
    private static let config = setConfiguration()
    
    private static func setConfiguration() -> Realm.Configuration {
        var configuration = Realm.Configuration()
        configuration.deleteRealmIfMigrationNeeded = true
        
        return configuration
    }
    
    static func saveNewsAttach (attachs: [NewsAttachments], newsId: String, authorId: String) {
        do {
            let realm = try Realm(configuration: config)
            let news = realm.object(ofType: News.self, forPrimaryKey: "\(newsId)\(authorId)")
            let oldAttachs = realm.objects(NewsAttachments.self).filter("postId == %@", "\(newsId)\(authorId)")
            try realm.write {
                realm.delete(oldAttachs)
                news?.attachments.append(objectsIn: attachs)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

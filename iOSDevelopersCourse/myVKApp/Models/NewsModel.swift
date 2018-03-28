//
//  NewsModel.swift
//  myVKApp
//
//  Created by Natalya on 25/03/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import RealmSwift
import SwiftyJSON

class News: Object {
    
    @objc dynamic var compoundKey: String = ""
    @objc dynamic var id: String = ""
    @objc dynamic var authorId: Int = 0
    @objc dynamic var author: String = ""
    @objc dynamic var authorImageUrl: String?
    @objc dynamic var date: Double = 0.0
    @objc dynamic var type: String = ""
    @objc dynamic var text: String = ""
    @objc dynamic var likesCount: String = ""
    @objc dynamic var commentsCount: String = ""
    @objc dynamic var repostsCount: String = ""
    @objc dynamic var viewsCount: String = ""
    
    var attachments = List<NewsAttachments>()
    var user = LinkingObjects(fromType: User.self, property: "newsfeed")
    
    @objc override open class func primaryKey() -> String? {
        return "compoundKey"
    }
    
    convenience init(json: JSON, userId: String, groups: [Group], friends: [Friend]) {
        self.init()
        self.id = json["post_id"].stringValue
        self.authorId = json["source_id"].intValue
        self.date = json["date"].doubleValue
        self.type = json["type"].stringValue
        self.text = json["text"].stringValue
        self.likesCount = json["likes"]["count"].stringValue
        self.commentsCount = json["comments"]["count"].stringValue
        self.repostsCount = json["reposts"]["count"].stringValue
        self.viewsCount = json["views"]["count"].stringValue
        self.compoundKey = "\(id)\(authorId)"
        
        if authorId > 0 {
            let friend = friends.filter({ $0.idFriend == authorId})
            
            self.author = friend[0].name
            self.authorImageUrl = friend[0].photoUrl
        } else {
            let group = groups.filter({$0.compoundKey == "\(authorId.magnitude)\(userId)"})
            
            self.author = group[0].nameGroup
            self.authorImageUrl = group[0].photoGroupUrl
        }
    }
}

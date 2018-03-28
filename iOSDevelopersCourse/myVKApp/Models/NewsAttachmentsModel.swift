//
//  NewsAttachmentsModel.swift
//  myVKApp
//
//  Created by Natalya on 27/03/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import RealmSwift
import SwiftyJSON

class NewsAttachments: Object {
    
    @objc dynamic var type: String = ""
    @objc dynamic var url: String?
    @objc dynamic var postId: String = ""
    
    var post = LinkingObjects(fromType: News.self, property: "attachments")
    
    convenience init(json: JSON, postId: String) {
        self.init()
        self.type = json["type"].stringValue
        self.postId = postId
        
        switch type {
        case "photo":
            self.url = json["\(type)"]["photo_604"].stringValue
        case "link":
            self.url = json["\(type)"]["photo"]["photo_604"].stringValue
        case "video":
            self.url = json["\(type)"]["photo_800"].stringValue
        default:
            self.url = json["\(type)"]["url"].stringValue
        }
    }
}

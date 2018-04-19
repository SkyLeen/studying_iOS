//
//  MessageAttachmentsModel.swift
//  myVKApp
//
//  Created by Natalya on 19/04/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import RealmSwift
import SwiftyJSON

class MessageAttachments: Object {
    
    @objc dynamic var type: String = ""
    @objc dynamic var url: String?
    @objc dynamic var msgId: String = ""
    
    var message = LinkingObjects(fromType: Message.self, property: "attachments")
    
    convenience init(json: JSON, msgId: String) {
        self.init()
        self.type = json["type"].stringValue
        self.msgId = msgId
        
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

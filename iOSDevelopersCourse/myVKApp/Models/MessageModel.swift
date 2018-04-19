//
//  MessageModel.swift
//  myVKApp
//
//  Created by Natalya on 01/04/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import RealmSwift
import SwiftyJSON

class Message: Object {
   
    @objc dynamic var id: String = ""
    @objc dynamic var body: String = ""
    @objc dynamic var readState: Int = 0
    @objc dynamic var date: Double = 0.0
    @objc dynamic var friendId: Int = 0
    @objc dynamic var fromId: Int = 0
    @objc dynamic var out: Int = 0
    @objc dynamic var attachmentType: String = ""
    
    var attachments = List<MessageAttachments>()
    
    @objc override open class func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(json: JSON) {
        self.init()
        
        self.id = json["id"].stringValue
        self.body = json["body"].stringValue
        self.readState = json["read_state"].intValue
        self.date = json["date"].doubleValue
        self.fromId = json["from_id"].intValue
        self.friendId = json["user_id"].intValue
        self.out = json["out"].intValue
        self.attachmentType = json["attachments"][0]["type"].stringValue
    }
}

//
//  DialogModel.swift
//  myVKApp
//
//  Created by Natalya on 25/03/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import RealmSwift
import SwiftyJSON

class Dialog: Object {
    
    @objc dynamic var id: String = ""
    @objc dynamic var body: String = ""
    @objc dynamic var readState: Int = 0
    @objc dynamic var date: Double = 0.0
    @objc dynamic var title: String = ""
    @objc dynamic var friendId: Int = 0
    @objc dynamic var friendName: String?
    @objc dynamic var friendPhotoUrl: String?
    @objc dynamic var out: Int = 0
    
    //var attachments = List<MessageAttachments>()
    var user = LinkingObjects(fromType: User.self, property: "dialogs")
    
    @objc override open class func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(json: JSON) {
        self.init()
        
        self.id = json["message"]["id"].stringValue
        self.body = json["message"]["body"].stringValue
        self.readState = json["message"]["read_state"].intValue
        self.date = json["message"]["date"].doubleValue
        self.title = json["message"]["title"].stringValue
        self.friendId = json["message"]["user_id"].intValue
        self.out = json["message"]["out"].intValue
    }
}

//
//  FriendRequestModel.swift
//  myVKApp
//
//  Created by Natalya on 16/05/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import RealmSwift
import SwiftyJSON

class FriendRequest: Object {
    
    @objc dynamic var id: Int = 0

    var user = LinkingObjects(fromType: User.self, property: "requests")
    
    @objc override open class func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(json: JSON) {
        self.init()
        self.id = json["user_id"].intValue
    }
    
}

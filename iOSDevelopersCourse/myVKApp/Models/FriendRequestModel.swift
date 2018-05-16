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
    
    @objc dynamic var id: String = ""
    @objc dynamic var online: Int = 0
    @objc dynamic private var firstName: String = ""
    @objc dynamic private var lastName: String = ""
    @objc dynamic var photoUrl: String?
    
    var name: String {
        get {
            let last = lastName == "" ? firstName : lastName
            return last + " " + firstName
        }
    }
    var user = LinkingObjects(fromType: User.self, property: "requests")
    
    @objc override open class func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(json: JSON) {
        self.init()
        self.id = json["id"].stringValue
        self.online = json["online"].intValue
        self.firstName = json["first_name"].stringValue
        self.lastName = json["last_name"].stringValue
        self.photoUrl = json["photo_100"].stringValue
    }
    
}

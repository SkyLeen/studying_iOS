//
//  UserModel.swift
//  myVKApp
//
//  Created by Natalya on 17/03/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import SwiftyJSON
import RealmSwift

class User: Object {
    
    @objc dynamic var idUser: String = ""
    @objc dynamic var lastName: String = ""
    @objc dynamic var firstName: String = ""
    @objc dynamic var photoUrl: String = ""
    var name: String {
        get {
            let last = lastName == "" ? firstName : lastName
            return last + " " + firstName
        }
    }
    
    var friends = List<Friend>()
    var groups = List<Group>()
    var newsfeed = List<News>()
    var dialogs = List<Dialog>()
    var requests = List<FriendRequest>()
    
    var makeAny: Any {
        return [
            "id":idUser,
            "last_name": lastName,
            "first_name": firstName,
            "photo_100": photoUrl
        ]
    }
    
    @objc override open class func primaryKey() -> String? {
        return "idUser"
    }
    
    convenience init(json: JSON) {
        self.init()
        self.idUser = json["id"].stringValue
        self.lastName = json["last_name"].stringValue
        self.firstName = json["first_name"].stringValue
        self.photoUrl = json["photo_100"].stringValue
    }
}


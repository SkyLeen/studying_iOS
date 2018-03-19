//
//  FriendModel.swift
//  myVKApp
//
//  Created by Natalya on 08/03/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class Friend: Object {
    
    @objc dynamic var idFriend: Int = 0
    @objc dynamic private var firstName: String = ""
    @objc dynamic private var lastName: String = ""
    @objc dynamic var photoUrl: String?
    var name: String {
        get {
            let last = lastName == "" ? firstName : lastName
            return last + " " + firstName
        }
    }
    
    var photos = List<Photos>()
    var user = LinkingObjects(fromType: User.self, property: "friends")
    
    @objc override open class func primaryKey() -> String? {
        return "idFriend"
    }
    
    convenience init(json: JSON) {
        self.init()
        self.idFriend = json["id"].intValue
        self.firstName = json["first_name"].stringValue
        self.lastName = json["last_name"].stringValue
        self.photoUrl = json["photo_100"].stringValue
    }
}

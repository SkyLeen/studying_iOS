//
//  FriendModel.swift
//  myVKApp
//
//  Created by Natalya on 08/03/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import SwiftyJSON
import RealmSwift
import CloudKit

class Friend: Object {
    
    @objc dynamic var idFriend: String = ""
    @objc dynamic var online: Int = 0
    @objc dynamic var firstName: String = ""
    @objc dynamic var lastName: String = ""
    @objc dynamic var photoUrl: String?
    @objc dynamic var userId: String = ""
    @objc dynamic var compoundKey: String = ""
    
    var name: String {
        get {
            let last = lastName == "" ? firstName : lastName
            return last + " " + firstName
        }
    }
    
    var photos = List<Photos>()
    var user = LinkingObjects(fromType: User.self, property: "friends")
    
    @objc override open class func primaryKey() -> String? {
        return "compoundKey"
    }
    
    convenience init(json: JSON, userId: String = "") {
        self.init()
        self.idFriend = json["id"].stringValue
        self.online = json["online"].intValue
        self.firstName = json["first_name"].stringValue
        self.lastName = json["last_name"].stringValue
        self.photoUrl = json["photo_100"].stringValue
        self.userId = userId
        self.compoundKey = "\(idFriend)\(userId)"
    }
    
    convenience  init(record: CKRecord) {
        self.init()
        self.idFriend = record.value(forKey: "idFriend") as! String
        self.online = record.value(forKey: "online") as! Int
        self.firstName = record.value(forKey: "firstName") as! String
        self.lastName = record.value(forKey: "lastName") as! String
        self.photoUrl = record.value(forKey: "photoUrl") as? String
        self.userId = record.value(forKey: "userId") as! String
        self.compoundKey = record.recordID.recordName
    }
}

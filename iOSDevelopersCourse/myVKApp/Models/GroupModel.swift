//
//  GroupModel.swift
//  myVKApp
//
//  Created by Natalya on 09/03/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import SwiftyJSON
import RealmSwift

class Group: Object {
    
    @objc dynamic var idGroup: String = ""
    @objc dynamic var nameGroup: String = ""
    @objc dynamic var followers: Int = 0
    @objc dynamic var photoGroupUrl: String?
    @objc dynamic var userId: String = ""
    @objc dynamic var compoundKey: String = ""
   
    var user = LinkingObjects(fromType: User.self, property: "groups")
    var makeAny: Any  {
       return [
        "name": nameGroup,
        "followers": followers,
        "photo": photoGroupUrl ?? "",
        "compoundKey":compoundKey
        ]
    }
    
    @objc override open class func primaryKey() -> String? {
        return "compoundKey"
    }
    
    convenience init(json: JSON, userId: String = "") {
        self.init()
        self.idGroup = json["id"].stringValue
        self.nameGroup = json["name"].stringValue
        self.followers = json["members_count"].intValue
        self.photoGroupUrl = json["photo_100"].stringValue
        self.userId = userId
        self.compoundKey = "\(idGroup)\(userId)"
    }
}

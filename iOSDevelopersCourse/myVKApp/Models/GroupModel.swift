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
   
    var user = LinkingObjects(fromType: User.self, property: "groups")
    var makeAny: Any  {
       return [
        "name": nameGroup,
        "followers": followers,
        "photo": photoGroupUrl ?? ""
        ]
    }
    
    @objc override open class func primaryKey() -> String? {
        return "idGroup"
    }
    
    convenience init(json: JSON, userId: String = "") {
        self.init()
        self.idGroup = json["id"].stringValue
        self.nameGroup = json["name"].stringValue
        self.followers = json["members_count"].intValue
        self.photoGroupUrl = json["photo_100"].stringValue
    }
}

//
//  GroupModel.swift
//  myVKApp
//
//  Created by Natalya on 09/03/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class Group: Object {
    
    @objc dynamic var idGroup: Int = 0
    @objc dynamic var nameGroup: String = ""
    @objc dynamic var followers: Int = 0
    @objc dynamic var photoGroupUrl: String?
    @objc dynamic var userId: String = ""
    @objc dynamic var compoundKey: String = ""
   
    var user = LinkingObjects(fromType: User.self, property: "groups")
    
    @objc override open class func primaryKey() -> String? {
        return "compoundKey"
    }
    
    convenience init(json: JSON, userId: String = "") {
        self.init()
        self.idGroup = json["id"].intValue
        self.nameGroup = json["name"].stringValue
        self.followers = json["members_count"].intValue
        self.photoGroupUrl = json["photo_50"].stringValue
        self.userId = userId
        self.compoundKey = "\(idGroup)\(userId)"
    }
}

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
    
    convenience init(json: JSON) {
        self.init()
        self.idGroup = json["id"].intValue
        self.nameGroup = json["name"].stringValue
        self.followers = json["members_count"].intValue
        self.photoGroupUrl = json["photo_50"].stringValue
    }
    
    convenience init(idGroup: Int, nameGroup: String, followers: Int, photoGroup: String?) {
        self.init()
        self.idGroup = idGroup
        self.nameGroup = nameGroup
        self.followers = followers
        self.photoGroupUrl = photoGroup
    }
}

//
//  GroupModel.swift
//  myVKApp
//
//  Created by Natalya on 09/03/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Group {
    
    var idGroup: Int = 0
    var nameGroup: String = ""
    var followers: Int = 0
    var photoGroupUrl: URL?
    
    init(json: JSON) {
        idGroup = json["id"].intValue
        nameGroup = json["name"].stringValue
        followers = json["members_count"].intValue
        photoGroupUrl = json["photo_50"].url
    }
    
    init(idGroup: Int, nameGroup: String, followers: Int, photoGroup: URL?) {
        self.idGroup = idGroup
        self.nameGroup = nameGroup
        self.followers = followers
        self.photoGroupUrl = photoGroup
    }
}

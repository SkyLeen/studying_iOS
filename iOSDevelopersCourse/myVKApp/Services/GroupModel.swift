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
    var photoGroup: UIImage = UIImage(named: "groups")!
    
    init(json: JSON) {
        self.idGroup = json["id"].intValue
        self.nameGroup = json["name"].stringValue
        self.followers = json["members_count"].intValue
        self.photoGroup = UIImage(data: try! Data(contentsOf: json["photo_50"].url!)) ?? UIImage(named: "groups")!
    }
    
    init(idGroup: Int, nameGroup: String, followers: Int, photoGroup: UIImage) {
        self.idGroup = idGroup
        self.nameGroup = nameGroup
        self.followers = followers
        self.photoGroup = photoGroup
    }
}

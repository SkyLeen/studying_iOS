//
//  PhotosModel.swift
//  myVKApp
//
//  Created by Natalya on 09/03/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class Photos: Object {
    
    @objc dynamic var idPhoto: Int = 0
    @objc dynamic var idFriend: Int = 0
    @objc dynamic var photoUrl: String?
    @objc dynamic var compoundKey: String = ""

    var friend = LinkingObjects(fromType: Friend.self, property: "photos")
    
    @objc override open class func primaryKey() -> String? {
        return "compoundKey"
    }
    
    convenience init(json: JSON) {
        self.init()
        self.idPhoto = json["id"].intValue
        self.idFriend = json["owner_id"].intValue
        self.photoUrl = json["photo_130"].stringValue
        self.compoundKey = "\(idPhoto)\(idFriend)"
    }
}

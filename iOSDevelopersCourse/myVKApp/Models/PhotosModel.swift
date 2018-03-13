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
    
    @objc dynamic var idUser: Int = 0
    @objc dynamic var photoUrl: String?
    
    convenience init(json: JSON) {
        self.init()
        self.idUser = json["owner_id"].intValue
        self.photoUrl = json["photo_130"].stringValue
    }
    
}

//
//  UserModel.swift
//  myVKApp
//
//  Created by Natalya on 17/03/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class User: Object {
    
    @objc dynamic var idUser: Int = 0
    
    var friends = List<Friend>()
    var groups = List<Group>()
    
    @objc override open class func primaryKey() -> String? {
        return "idUser"
    }
    
    convenience init(idUser: Int) {
        self.init()
        self.idUser = idUser
    }
}


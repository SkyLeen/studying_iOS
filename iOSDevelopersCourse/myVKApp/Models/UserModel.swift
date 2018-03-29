//
//  UserModel.swift
//  myVKApp
//
//  Created by Natalya on 17/03/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import SwiftyJSON
import RealmSwift

class User: Object {
    
    @objc dynamic var idUser: String = ""
    
    var friends = List<Friend>()
    var groups = List<Group>()
    var newsfeed = List<News>()
    var dialogs = List<Dialog>()
    
    @objc override open class func primaryKey() -> String? {
        return "idUser"
    }
    
    convenience init(idUser: String) {
        self.init()
        self.idUser = idUser
    }
}


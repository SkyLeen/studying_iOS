//
//  UserModel.swift
//  myVKApp
//
//  Created by Natalya on 08/03/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import Foundation
import SwiftyJSON

struct User {
    
    var idUser: Int = 0
    private var firstName: String = ""
    private var lastName: String = ""
    var photoUrl: URL?
    var name: String {
        get {
            let last = lastName == "" ? firstName : lastName
            return last + " " + firstName
        }
    }
    
    init(json: JSON) {
        idUser = json["id"].intValue
        firstName = json["first_name"].stringValue
        lastName = json["last_name"].stringValue
        photoUrl = json["photo_100"].url
    }
}

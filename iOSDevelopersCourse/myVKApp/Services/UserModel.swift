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
    var photo: UIImage = UIImage(named: "friends")!
    var name: String {
        get {
            let last = lastName == "" ? firstName : lastName
            return last + " " + firstName
        }
    }
    
    init(json: JSON) {
        self.idUser = json["id"].intValue
        self.firstName = json["first_name"].stringValue
        self.lastName = json["last_name"].stringValue
        self.photo = UIImage(data: try! Data(contentsOf: json["photo_100"].url!)) ?? UIImage(named: "friends")!
    }
}

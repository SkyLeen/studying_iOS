//
//  PhotosModel.swift
//  myVKApp
//
//  Created by Natalya on 09/03/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Photos {
    var idUser: Int = 0
    var photos: UIImage = UIImage(named: "friends")!
    
    init(json: JSON) {
        self.idUser = json["owner_id"].intValue
        self.photos = UIImage(data: try! Data(contentsOf: json["photo_130"].url!))!
    }
    
}

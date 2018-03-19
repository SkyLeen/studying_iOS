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
    var photoUrl: URL?
    
    init(json: JSON) {
        idUser = json["owner_id"].intValue
        photoUrl = json["photo_130"].url
    }
    
}

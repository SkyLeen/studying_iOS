//
//  AuthorizationModel.swift
//  myVKApp
//
//  Created by Natalya on 03/03/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import Foundation

struct Authorization {
    var accessToken: String = ""
    var userId: String = ""
    var dataAccessToken: NSDate = NSDate()
}

//
//  LogOutRequest.swift
//  myVKApp
//
//  Created by Natalya on 09/03/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import Foundation
import Alamofire

class LogOutRequest {
    func logOut() {
        let storage = HTTPCookieStorage.shared
        for cookie in storage.cookies! {
            let domainName = cookie.domain
            let domainRange = domainName.range(of: "vk.com")
            guard !(domainRange?.isEmpty)! else { return }
            storage.deleteCookie(cookie)
        }

    }
}

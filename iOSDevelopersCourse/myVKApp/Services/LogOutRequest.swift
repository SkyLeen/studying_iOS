//
//  LogOutRequest.swift
//  myVKApp
//
//  Created by Natalya on 09/03/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper
import RealmSwift

class LogOutRequest {
    
    func logOut() {
        removeDefaults()
        removeCookies()
        removeDataBase()
    }
    
    private func removeDefaults() {
        let userDefaults = UserDefaults.standard
        let keyChain = KeychainWrapper.standard
        userDefaults.removeObject(forKey: "isLogged")
        keyChain.removeObject(forKey: "accessToken")
        keyChain.removeObject(forKey: "userId")
    }
    
    private func removeCookies() {
        let storage = HTTPCookieStorage.shared
        for cookie in storage.cookies! {
            let domainName = cookie.domain
            guard let _ = domainName.range(of: "vk.com") else { return }
            storage.deleteCookie(cookie)
        }
    }
    
    private func removeDataBase() {
        do {
            let realm = try Realm()
            try realm.write {
                realm.deleteAll()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

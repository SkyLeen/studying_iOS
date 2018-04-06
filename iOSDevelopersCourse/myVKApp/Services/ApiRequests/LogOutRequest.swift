//
//  LogOutRequest.swift
//  myVKApp
//
//  Created by Natalya on 09/03/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import SwiftKeychainWrapper
import RealmSwift

class LogOutRequest {
    
    static func logOut() {
        removeDefaults()
        removeCookies()
        removeDataBase()
        removeCash()
    }
    
    private static func removeDefaults() {
        let userDefaults = UserDefaults.standard
        let keyChain = KeychainWrapper.standard
        userDefaults.removeObject(forKey: "isLogged")
        keyChain.removeObject(forKey: "accessToken")
        keyChain.removeObject(forKey: "userId")
    }
    
    private static func removeCookies() {
        let storage = HTTPCookieStorage.shared
        for cookie in storage.cookies! {
            let domainName = cookie.domain
            guard let _ = domainName.range(of: "vk.com") else { return }
            storage.deleteCookie(cookie)
        }
    }
    
    private static func removeDataBase() {
        do {
            let realm = try Realm()
            try realm.write {
                realm.deleteAll()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private static func removeCash() {
        guard let cashDir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return }
        do {
            try FileManager.default.removeItem(at: cashDir.asURL())
        } catch {
            print(error.localizedDescription)
        }
    }
}

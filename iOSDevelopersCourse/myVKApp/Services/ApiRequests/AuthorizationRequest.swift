//
//  AuthorizationRequest.swift
//  myVKApp
//
//  Created by Natalya on 03/03/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import SwiftKeychainWrapper
import RealmSwift

class AuthorizationRequest {
    
    let userDefaults = UserDefaults.standard
    let keyChain = KeychainWrapper.standard
    let scheme = "https"
    let baseHost = "oauth.vk.com"
    let cliendId = "6389925"
    
    func requestAuthorization() -> URLRequest {
        let path = "/authorize"
        let urlRedirect = "https://oauth.vk.com/blank.html"
        
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = baseHost
        urlComponents.path = path
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: cliendId),
            URLQueryItem(name: "scope", value: "groups"),
            URLQueryItem(name: "display", value: "page"),
            URLQueryItem(name: "redirect_uri", value: urlRedirect),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.73")
        ]
        
        let request = URLRequest(url: urlComponents.url!)
        return request
    }
    
    func setAuthorizationResult(url: URL) {
        let urlFragment = url.fragment!
        let params = getParamsDictionary(urlFragment: urlFragment)
        
        if (url.absoluteString.range(of: "access_token") != nil) {
            userDefaults.set(true, forKey: "isLogged")
            keyChain.set(params["access_token"]!, forKey: "accessToken")
            keyChain.set(params["user_id"]!, forKey: "userId")
            
            loadUserData(userId: String(params["user_id"]!))
        }
    }
    
    private func getParamsDictionary(urlFragment: String) -> Dictionary<String,String> {
        let params = urlFragment
                    .components(separatedBy: "&")
                    .map { $0.components(separatedBy: "=") }
                    .reduce([String:String]()) { key,value in
                        var dict = key
                        let key = value[0]
                        let value = value[1]
                        dict[key] = value
                        return dict
                }
        return params
    }
    
    private func loadUserData(userId: String) {
        createUser(userId: userId)
    }
    
    private func createUser(userId: String) {
        var configuration = Realm.Configuration()
        configuration.deleteRealmIfMigrationNeeded = true
        
        let user = User(idUser: userId)
        
        do {
            let realm = try Realm(configuration: configuration)
            try realm.write {
                realm.add(user, update: true)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
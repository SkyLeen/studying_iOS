//
//  AuthorizationRequest.swift
//  myVKApp
//
//  Created by Natalya on 03/03/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import SwiftKeychainWrapper

class AuthorizationRequest {
    
    static let userDefaults = UserDefaults.standard
    static let keyChain = KeychainWrapper.standard
    static let scheme = "https"
    static let baseHost = "oauth.vk.com"
    static let cliendId = "6389925"
    
    static func requestAuthorization() -> URLRequest {
        let path = "/authorize"
        let urlRedirect = "https://oauth.vk.com/blank.html"
        
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = baseHost
        urlComponents.path = path
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: cliendId),
            URLQueryItem(name: "scope", value: "offline, photos, groups, wall, friends, messages"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: urlRedirect),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.73")
        ]
        
        let request = URLRequest(url: urlComponents.url!)
        return request
    }
    
    static func setAuthorizationResult(url: URL) {
        let urlFragment = url.fragment!
        let params = getParamsDictionary(urlFragment: urlFragment)
        
        if (url.absoluteString.range(of: "access_token") != nil) {
            userDefaults.set(true, forKey: "isLogged")
            keyChain.set(params["access_token"]!, forKey: "accessToken")
            keyChain.set(params["user_id"]!, forKey: "userId")
            
            UserRequests.getUserById(userId: params["user_id"]!, accessToken: params["access_token"]!, requestUserId: params["user_id"]!, attribute: .mainUser)
        }
    }
    
    private static func getParamsDictionary(urlFragment: String) -> Dictionary<String,String> {
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
}

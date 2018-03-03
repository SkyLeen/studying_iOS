//
//  NetworkRequest.swift
//  myVKApp
//
//  Created by Natalya on 03/03/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import Foundation

class NetworkRequest {
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
            URLQueryItem(name: "display", value: "page"),
            URLQueryItem(name: "redirect_uri", value: urlRedirect),
            URLQueryItem(name: "revoke", value: "1"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.73")
        ]
        
        let request = URLRequest(url: urlComponents.url!)
        
        return request
    }
    
    func getAuthorizationResult(url: URL) -> (type: AuthorizationResult, text: String) {
        var result = (type: AuthorizationResult.defaultResult , text: "Default")
        guard let urlFragment = url.fragment else { return result }
        
        let params = getParamsDictionary(urlFragment: urlFragment)
        
        if (url.absoluteString.range(of: "access_token") != nil) {
            result = (type: .accessToken, text: params["access_token"]!)
        } else if (url.absoluteString.range(of: "error") != nil) {
            result = (type: .error, text: params["error"]!)
        }
        return result
    }
    
    private func getParamsDictionary(urlFragment: String) -> Dictionary<String,String> {
        let params = urlFragment
                    .components(separatedBy: "&")
                    .map { $0.components(separatedBy: "=") }
                    .reduce([String:String]()) { result,param in
                        var dict = result
                        let key = param[0]
                        let value = param[1]
                        dict[key] = value
                        return dict
                }
        return params
    }
}

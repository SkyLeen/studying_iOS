//
//  DialogsRequests.swift
//  myVKApp
//
//  Created by Natalya on 25/03/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import Alamofire
import SwiftyJSON

class DialogsRequests {
    
    static let baseUrl = "https://api.vk.com"
    static let path = "/method"
    
    static func getUserDialogs(userId: String, accessToken: String) {
        let pathMethod = "/messages.getDialogs"
        let url = baseUrl + path + pathMethod
        let parameters: Parameters = [
            "access_token":accessToken,
            "count":200,
            //"start_message_id":0,
            "v":"5.73"
        ]
       
        
        Alamofire.request(url, method: .get, parameters: parameters).validate().responseJSON {  response in
            switch response.result {
            case .success(let value):
                RealmDeleter.removeDialogs()
                let dialogs = JSON(value)["response"]["items"]
                for item in dialogs {
                    let dialog = Dialog(json: item.1)
                    RealmDialogSaver.saveUserNews(dialog: dialog, userId: userId)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

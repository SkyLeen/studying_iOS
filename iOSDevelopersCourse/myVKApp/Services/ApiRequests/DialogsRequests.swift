//
//  DialogsRequests.swift
//  myVKApp
//
//  Created by Natalya on 25/03/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import Alamofire
import SwiftyJSON
import SwiftKeychainWrapper

class DialogsRequests {
    
    static let accessToken = KeychainWrapper.standard.string(forKey: "accessToken")
    static let userId =  KeychainWrapper.standard.string(forKey: "userId")
    
    static let baseUrl = "https://api.vk.com"
    static let path = "/method"
    static let version = "5.74"
    
    static func getUserDialogs() {
        let pathMethod = "/messages.getDialogs"
        let url = baseUrl + path + pathMethod
        let parameters: Parameters = [
            "access_token":accessToken!,
            "count":200,
            //"start_message_id":0,
            "v":version
        ]
               
        Alamofire.request(url, method: .get, parameters: parameters).validate().responseJSON(queue: DispatchQueue.global(qos: .utility)) {  response in
            switch response.result {
            case .success(let value):
                let dialogs = JSON(value)["response"]["items"]
                for item in dialogs {
                    let dialog = Dialog(json: item.1)
                    
                    if RealmRequests.getFriendData(friend: "\(dialog.friendId)") == nil {
                        if dialog.friendId > 0 {
                            UserRequests.getUserById(userId: userId!, accessToken: accessToken!, requestUserId: "\(dialog.friendId)", attribute: .fromDialogs)
                        } else {
                            GroupsRequests.getGroupById(idGroup: "\(dialog.friendId.magnitude)")
                        }
                    }
                }
                RealmDialogSaver.saveUserDialogs(dialog: dialogs.compactMap({ Dialog(json: $0.1)}), userId: userId!)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    static func getMessages(friendId: String) {
        let pathMethod = "/messages.getHistory"
        let url = baseUrl + path + pathMethod
        let parameters: Parameters = [
            "access_token":accessToken!,
            "user_id":friendId,
            "count":200,
            //"start_message_id":0,
            "v":version
        ]
        
        Alamofire.request(url, method: .get, parameters: parameters).validate().responseJSON(queue: DispatchQueue.global(qos: .utility)) {  response in
            switch response.result {
            case .success(let value):
                let _ = JSON(value)["response"]["count"]
                let messages = JSON(value)["response"]["items"].compactMap({ Message(json: $0.1) })
                RealmDialogSaver.saveMessages(messages: messages)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    static func sendMessage(to friendId: Int, chatId: Int = 0, text: String = "", attachment: String = "") {
        let pathMethod = "/messages.send"
        let url = baseUrl + path + pathMethod
        let parameters: Parameters = [
            "access_token":accessToken!,
            //"user_id":userId!,
            "peer_id":friendId,
            "chat_id":chatId,
            "message":text,
            "attachment":attachment,
            "v":version
        ]
        
        Alamofire.request(url, method: .get, parameters: parameters).validate().responseJSON {  response in
            switch response.result {
            case .success(let value):
                let id = JSON(value)["response"].stringValue
                if id != "" {
                    var messages: [Message] = []
                    let message = Message()
                    message.body = text
                    message.date = Date().timeIntervalSince1970
                    message.friendId = friendId
                    message.fromId = Int(userId!)!
                    message.readState = 0
                    message.out = 1
                    message.id = id
                    messages.append(message)
                    RealmDialogSaver.saveMessages(messages: messages)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

//
//  NewsRequests.swift
//  myVKApp
//
//  Created by Natalya on 25/03/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import Alamofire
import SwiftyJSON
import SwiftKeychainWrapper

class NewsRequests {
    
    static private let accessToken = KeychainWrapper.standard.string(forKey: "accessToken")
    static private let userId =  KeychainWrapper.standard.string(forKey: "userId")
    
    static let baseUrl = "https://api.vk.com"
    static let path = "/method"
    static let version = "5.74"
    static var offset = 0
    static var start_from = ""
    
    static func getUserNews(userId: String, accessToken: String) {
        let pathMethod = "/newsfeed.get"
        let url = baseUrl + path + pathMethod
        let parameters: Parameters = [
            "user_id":userId,
            "access_token":accessToken,
            "filters":"post", //,photo,photo_tag, wall_photo
            "count":100,
            //"offset":0,
            //"start_from":0,
            "v":version
        ]
        
        Alamofire.request(url, method: .get, parameters: parameters).validate().responseJSON(queue: DispatchQueue.global(qos: .utility)) {  response in
            switch response.result {
            case .success(let value):
                let profiles = JSON(value)["response"]["profiles"].compactMap({ Friend(json: $0.1, userId: userId) })
                let groups = JSON(value)["response"]["groups"].compactMap({ Group(json: $0.1, userId: userId) })
                let newsFeed = JSON(value)["response"]["items"]
                let news = newsFeed.compactMap({ News(json: $0.1, userId: userId, groups: groups, friends: profiles) })
                RealmNewsSaver.saveUserNews(news: news, userId: userId)
                
                DispatchQueue.global(qos: .utility).async {
                    for (_,item) in newsFeed.enumerated() {
                        let postId = item.1["post_id"].stringValue
                        let authorId = item.1["source_id"].stringValue
                        let attachments = item.1["attachments"].compactMap({ NewsAttachments(json: $0.1, postId: "\(postId)\(authorId)") })
                        RealmNewsAttachSaver.saveNewsAttach(attachs: attachments, newsId: postId, authorId: authorId)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    static func postNews(text: String = "", attachment: [Photos]?, lat: Double = 0.0, long: Double = 0.0) {
        var attachments = ""
        
        if let attachedImages = attachment, !attachedImages.isEmpty {
            for image in attachedImages {
                attachments += "photo\(image.idFriend.description)_\(image.idPhoto.description),"
            }
            attachments.removeLast()
        }
        
        let pathMethod = "/wall.post"
        let url = baseUrl + path + pathMethod
        let parameters: Parameters = [
            "owner_id":userId!,
            "access_token":accessToken!,
            "message": text,
            "attachments": attachments,
            "signed":1,
            "lat":lat,
            "long":long,
            "v":version
        ]
         Alamofire.request(url, method: .get, parameters: parameters).validate().responseJSON(queue: DispatchQueue.global(qos: .utility)) {  response in
            switch response.result {
            case .success(let value):
                print(JSON(value))
                NewsRequests.getUserNews(userId: userId!, accessToken: accessToken!)
            case .failure(let error):
                print(error)
            }
        }
    }
}

//
//  NewsRequests.swift
//  myVKApp
//
//  Created by Natalya on 25/03/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import Alamofire
import SwiftyJSON

class NewsRequests {
    
    static let baseUrl = "https://api.vk.com"
    static let path = "/method"
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
            "v":"5.73"
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
}

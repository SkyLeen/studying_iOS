//
//  PhotosRequests.swift
//  myVKApp
//
//  Created by Natalya on 11/06/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import Alamofire
import SwiftyJSON
import SwiftKeychainWrapper

class PhotosRequests {
    
    static let accessToken = KeychainWrapper.standard.string(forKey: "accessToken")
    static let userId =  KeychainWrapper.standard.string(forKey: "userId")
    
    static let baseUrl = "https://api.vk.com"
    static let path = "/method"
    static let version = "5.74"
    
    static func uploadPhotosToServer(_ imageUrl: URL, completion: @escaping ([Photos]?) -> ()) {
       
        let pathMethod = "/photos.getWallUploadServer"
        let url = baseUrl + path + pathMethod
        let parameters: Parameters = [
            "access_token":accessToken!,
            "signed":1,
            "v":version
        ]
        Alamofire.request(url, method: .get, parameters: parameters).validate().responseJSON(queue: DispatchQueue.global(qos: .utility)) {  response in
            switch response.result {
            case .success(let value):
                let uploadUrl = JSON(value)["response"]["upload_url"].stringValue
                uploadPhotos(uploadUrl, imageUrl: imageUrl) { (photo, server, hash) in
                    savePhotos(photo, server: server, hash: hash) { photos in
                        completion(photos)
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    static private func uploadPhotos(_ uploadUrl: String, imageUrl: URL, completion: @escaping (String, Int, String) -> ()) {
        guard let url = URL(string: uploadUrl) else { return }
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageUrl, withName: "photo")
        }, to: url) { response in
            switch response {
            case .success(let upload, _, _):
                upload.responseJSON(completionHandler: { response in
                    let photo = JSON(response.data!)["photo"].stringValue
                    let server = JSON(response.data!)["server"].intValue
                    let hash = JSON(response.data!)["hash"].stringValue
        
                    completion(photo, server, hash)
                })
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    static private func savePhotos(_ photo: String, server: Int, hash: String, completion: @escaping ([Photos]?) -> ()) {
        
        let pathMethod = "/photos.saveWallPhoto"
        let url = baseUrl + path + pathMethod
        let parameters: Parameters = [
            "user_id":userId!,
            "photo":photo,
            "server":server,
            "hash":hash,
            "access_token":accessToken!,
            "v":version
        ]
        Alamofire.request(url, method: .get, parameters: parameters).validate().responseJSON(queue: DispatchQueue.global(qos: .utility)) {  response in
            switch response.result {
            case .success(let value):
                let photos = JSON(value)["response"].compactMap({ Photos(json: $0.1) })
                completion(photos)
            case .failure(let error):
                print(error)
            }
        }
    }
}

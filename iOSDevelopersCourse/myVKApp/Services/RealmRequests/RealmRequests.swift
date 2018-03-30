//
//  RealmRequests.swift
//  myVKApp
//
//  Created by Natalya on 30/03/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import RealmSwift

class RealmRequests {
    
    static func getFriendData(friend: String) -> (name: String, photoUrl: String?)? {
        guard let realm = try? Realm() else { return nil }
        
        let friend = realm.objects(Friend.self).filter("idFriend == %@", friend)
        if !friend.isEmpty {
            let name = friend[0].name
            let photoUrl = friend[0].photoUrl
            
            return (name: name, photoUrl: photoUrl)
        } else { return nil }
    }
}

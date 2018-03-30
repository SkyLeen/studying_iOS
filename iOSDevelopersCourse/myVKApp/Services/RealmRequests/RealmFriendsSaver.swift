//
//  RealmFriendsSaver.swift
//  myVKApp
//
//  Created by Natalya on 20/03/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import RealmSwift

class RealmFriendsSaver {
    
    private static let config = setConfiguration()
    
    private static func setConfiguration() -> Realm.Configuration {
        var configuration = Realm.Configuration()
        configuration.deleteRealmIfMigrationNeeded = true
        
        return configuration
    }

    static func saveFriendsData(friends: [Friend], userId: String) {
        do {
            let realm = try Realm(configuration: config)
            let user = realm.object(ofType: User.self, forPrimaryKey: userId)
            let oldFriends = realm.objects(Friend.self)
            let oldFriendsPhotos = realm.objects(Photos.self)
            try realm.write {
                print(realm.configuration.fileURL!)
                realm.delete(oldFriends)
                realm.delete(oldFriendsPhotos)
                user?.friends.append(objectsIn: friends)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    static func saveFriendsPhotos (photos: [Photos], friendId: String) {
        do {
            let realm = try Realm(configuration: config)
            let friend = realm.object(ofType: Friend.self, forPrimaryKey: friendId)
            let oldPhotos = realm.objects(Photos.self).filter("idFriend == %@", friendId)
            try realm.write {
                realm.delete(oldPhotos)
                friend?.photos.append(objectsIn: photos)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    static func saveSingleFriend (friends: Friend, userId: String) {
        do {
            let realm = try Realm(configuration: config)
            let user = realm.object(ofType: User.self, forPrimaryKey: userId)
            
            let oldFriend = realm.object(ofType: Friend.self, forPrimaryKey: friends.compoundKey)
            let friend = realm.object(ofType: Friend.self, forPrimaryKey: "\(friends.idFriend)\(userId)")
            
            try realm.write {
                if oldFriend != nil { realm.delete(oldFriend!) }
                
                guard friend == nil else { return }
                user?.friends.append(friends)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

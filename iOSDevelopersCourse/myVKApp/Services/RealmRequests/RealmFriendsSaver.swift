//
//  RealmFriendsSaver.swift
//  myVKApp
//
//  Created by Natalya on 20/03/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import RealmSwift

class RealmFriendsSaver {
    
    static func saveFriendsData(friends: [Friend], userId: String) {
        do {
            let realm = try Realm()
            let user = realm.object(ofType: User.self, forPrimaryKey: userId)
            let oldFriends = realm.objects(Friend.self)
            let oldFriendsPhotos = realm.objects(Photos.self)
            try realm.write {
                realm.delete(oldFriends)
                realm.delete(oldFriendsPhotos)
                user?.friends.append(objectsIn: friends)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    static func saveFriendsPhotos (photos: [Photos], friendId: String, userId: String) {
        do {
            let realm = try Realm()
            let friend = realm.object(ofType: Friend.self, forPrimaryKey: "\(friendId)\(userId)")
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
            let realm = try Realm()
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
    static func saveFriend (friends: Friend) {
        do {
            let realm = try Realm()
            
            try realm.write {
                realm.add(friends, update: true)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    static func saveFriendsRequested(friends: [FriendRequest], userId: String) {
        do {
            let realm = try Realm()
            let user = realm.object(ofType: User.self, forPrimaryKey: userId)
            
            //let oldRequest = realm.objects(FriendRequest.self)
            
            try realm.write {
                //realm.delete(oldRequest)

                user?.requests.append(objectsIn: friends)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
}

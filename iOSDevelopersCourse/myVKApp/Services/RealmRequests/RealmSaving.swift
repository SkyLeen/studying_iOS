//
//  RealmSaving.swift
//  myVKApp
//
//  Created by Natalya on 20/03/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import RealmSwift

class Saver {
    
    static let config = setConfiguration()
    
    static func setConfiguration() -> Realm.Configuration {
        var configuration = Realm.Configuration()
        configuration.deleteRealmIfMigrationNeeded = true
        Realm.Configuration.defaultConfiguration = configuration
        
        return configuration
    }

    static func loadFriendsData(friends: [Friend], userId: String) {
        do {
            let realm = try Realm(configuration: config)
            let user = realm.object(ofType: User.self, forPrimaryKey: userId)
            let oldFriends = realm.objects(Friend.self)
            try realm.write {
                realm.delete(oldFriends)
                for friend in friends {
                    user?.friends.append(friend)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    static func loadFriendsPhotos (photos: [Photos], friendId: Int) {
        do {
            let realm = try Realm(configuration: config)
            let friend = realm.object(ofType: Friend.self, forPrimaryKey: friendId)
            let oldPhotos = realm.objects(Photos.self).filter("idFriend == %@", friendId)
            try realm.write {
                realm.delete(oldPhotos)
                for photo in photos {
                    friend?.photos.append(photo)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    static func loadUserGroups(groups: [Group], userId: String) {
        do {
            let realm = try Realm(configuration: config)
            let user = realm.object(ofType: User.self, forPrimaryKey: userId)
            let oldGroups = realm.objects(Group.self).filter("userId == %@", userId)
            try realm.write {
                realm.delete(oldGroups)
                for group in groups {
                    user?.groups.append(group)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    static func loadAllGroups(groups: [Group]) {
        do {
            let realm = try Realm(configuration: config)
            try realm.write {
                realm.add(groups,update: true)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

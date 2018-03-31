//
//  MyFriendCollectionVC.swift
//  myVKApp
//
//  Created by Natalya on 24/02/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import RealmSwift

class MyFriendCollectionVC: UICollectionViewController {

    let accessToken = KeychainWrapper.standard.string(forKey: "accessToken")
    let userId =  KeychainWrapper.standard.string(forKey: "userId")
    
    var friendName = String()
    let interItemSpace: CGFloat = 5
    var friendId = ""
    
    lazy var friendPhotos: Results<Photos> = {
        return RealmLoader.loadData(object: Photos()).filter("idFriend == %@", friendId)
    }()
    
    var photoToken: NotificationToken?
    
    deinit {
        photoToken?.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = friendName
        
        FriendsRequests.getFriendPhotos(userId: self.userId!, accessToken: self.accessToken!, friendId: self.friendId)
        getNotification()
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return friendPhotos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendPhotoCell", for: indexPath) as! MyFriendCollectionViewCell
    
        cell.photo = friendPhotos[indexPath.row]
    
        return cell
    }
}

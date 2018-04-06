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
    
    var opQueue: OperationQueue = {
        let q = OperationQueue()
        q.qualityOfService = .userInteractive
        return q
    }()
    
    deinit {
        photoToken?.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = friendName
        
        FriendsRequests.getFriendPhotos(userId: self.userId!, accessToken: self.accessToken!, friendId: self.friendId)
        photoToken = Notifications.getCollectionViewToken(friendPhotos, view: self.collectionView)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return friendPhotos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendPhotoCell", for: indexPath) as! MyFriendCollectionViewCell
        let photo = friendPhotos[indexPath.row]
        
        guard let url = photo.photo75Url else { return cell }
        let getImageOp = GetCashedImage(url: url, folderName: .Photos, userId: photo.idFriend)
        let cellReloadedOp = CollectionCellReloading(indexPath: indexPath, view: collectionView, cell: cell, imageView: cell.myFriendPhoto)
        cellReloadedOp.addDependency(getImageOp)
        opQueue.addOperation(getImageOp)
        OperationQueue.main.addOperation(cellReloadedOp)
    
        return cell
    }
}

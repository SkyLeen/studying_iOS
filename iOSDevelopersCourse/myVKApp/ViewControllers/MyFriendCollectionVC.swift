//
//  MyFriendCollectionVC.swift
//  myVKApp
//
//  Created by Natalya on 24/02/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit
import RealmSwift

class MyFriendCollectionVC: UICollectionViewController {
    
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
        
        FriendsRequests.getFriendPhotos(friendId: self.friendId)
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


extension MyFriendCollectionVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsCount: CGFloat = 4
        let screenWidth = collectionView.bounds.size.width
        let itemWidth = (screenWidth - (interItemSpace * itemsCount))/itemsCount
        
        let cellSize = CGSize(width: itemWidth, height: itemWidth)
        
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return interItemSpace
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return interItemSpace
    }
}

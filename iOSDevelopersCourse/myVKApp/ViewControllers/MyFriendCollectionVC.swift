//
//  MyFriendCollectionVC.swift
//  myVKApp
//
//  Created by Natalya on 24/02/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit


class MyFriendCollectionVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var friendName = String()
    var friendPhotos = [Photos]()
    let interItemSpace: CGFloat = 5
    
    var friendId = 0
    var accessToken = ""
    var userId = ""
    var photosRequest = MethodRequest()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photosRequest.getFriendPhotos(userId: userId, accessToken: accessToken, friendId: friendId) { [weak self] photos in
            self?.friendPhotos = photos
            self?.collectionView?.reloadData()
        }
        navigationItem.title = friendName 
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return friendPhotos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendPhotoCell", for: indexPath) as! MyFriendCollectionViewCell
    
        cell.myFriendPhoto.image = friendPhotos[indexPath.row].photos
    
        return cell
    }
    
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

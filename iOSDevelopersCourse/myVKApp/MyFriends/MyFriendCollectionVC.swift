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
    var friendPhoto = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = friendName 
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendPhotoCell", for: indexPath) as! MyFriendCollectionViewCell
    
        cell.myFriendPhoto.image = friendPhoto
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let navigationBarSize = (self.navigationController?.navigationBar.bounds)!
        let viewSize = collectionView.bounds
        let cellWidth = viewSize.width
        let cellHeight = viewSize.height - navigationBarSize.height
        
        let cellSize = CGSize(width: cellWidth, height: cellHeight)
        
        return cellSize
    }
    
}

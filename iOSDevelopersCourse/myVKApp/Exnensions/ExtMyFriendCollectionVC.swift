//
//  ExtMyFriendCollectionVC.swift
//  myVKApp
//
//  Created by Natalya on 22/03/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import Foundation
import UIKit

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

extension MyFriendCollectionVC {
    
    func getNotification() {
        token = friendPhotos.observe({ [weak self] changes in
            guard let collect = self?.collectionView else { return }
            switch changes {
            case .initial:
                collect.reloadData()
            case .update(_, let delete, let insert, let update):
                collect.performBatchUpdates({
                    collect.deleteItems(at: delete.map({ IndexPath(row: $0, section: 0) }))
                    collect.insertItems(at: insert.map({ IndexPath(row: $0, section: 0) }))
                    collect.reloadItems(at: update.map({ IndexPath(row: $0, section: 0) }))
                }, completion: nil)
            case .error(let error):
                print(error.localizedDescription)
            }
        })
    }
}

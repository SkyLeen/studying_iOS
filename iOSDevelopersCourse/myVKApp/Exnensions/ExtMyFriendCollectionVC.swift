//
//  ExtMyFriendCollectionVC.swift
//  myVKApp
//
//  Created by Natalya on 22/03/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import Foundation

extension MyFriendCollectionVC {
    
    func getNotification() {
        
        friendPhotos = Loader.loadData(object: Photos()).filter("idFriend == %@", friendId)
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

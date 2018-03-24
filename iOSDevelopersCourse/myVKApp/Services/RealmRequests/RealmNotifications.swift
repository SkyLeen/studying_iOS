//
//  RealmNotifications.swift
//  myVKApp
//
//  Created by Natalya on 21/03/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import RealmSwift

class Notificator {
    
    static func getNotificationForTableVC<T: Object>(for objects: Results<T>, tableView: UITableView) -> NotificationToken {
        let token = objects.observe({ changes in
            switch changes {
            case .initial:
                tableView.reloadData()
            case .update(_, let delete, let insert, let update):
                tableView.beginUpdates()
                tableView.deleteRows(at: delete.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                tableView.insertRows(at: insert.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                tableView.reloadRows(at: update.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                tableView.endUpdates()
            case .error(let error):
                print(error.localizedDescription)
            }
        })
        return token
    }
    
    static func getNotificationForCollectionVC<T: Object>(for objects: Results<T>, collectView: UICollectionView) -> NotificationToken {
        let token = objects.observe({ changes in
            switch changes {
            case .initial:
                collectView.reloadData()
            case .update(_, let delete, let insert, let update):
                collectView.performBatchUpdates({
                    collectView.deleteItems(at: delete.map({ IndexPath(row: $0, section: 0) }))
                    collectView.insertItems(at: insert.map({ IndexPath(row: $0, section: 0) }))
                    collectView.reloadItems(at: update.map({ IndexPath(row: $0, section: 0) }))
                }, completion: nil)
            case .error(let error):
                print(error.localizedDescription)
            }
        })
        return token
    }
}

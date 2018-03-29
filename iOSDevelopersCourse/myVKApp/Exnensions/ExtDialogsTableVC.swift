//
//  ExtDialogsTableVC.swift
//  myVKApp
//
//  Created by Natalya on 29/03/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import RealmSwift
import UIKit

extension DialogsTableVC {
    
    func getNotification() {
        token = dialogsArray.observe({ [weak self] changes in
            guard let view = self?.tableView else { return }
            switch changes {
            case .initial:
                view.reloadData()
            case .update(_, let delete, let insert, let update):
                view.beginUpdates()
                view.deleteRows(at: delete.map({ IndexPath(row: $0, section: 0) }), with: .fade)
                view.insertRows(at: insert.map({ IndexPath(row: $0, section: 0) }), with: .fade)
                view.reloadRows(at: update.map({ IndexPath(row: $0, section: 0) }), with: .fade)
                view.endUpdates()
            case .error(let error):
                print(error.localizedDescription)
            }
        })
    }
}

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
    
    func getDialogsNotification() {
        dialogsArray = RealmLoader.loadData(object: Dialog()).sorted(byKeyPath: "date", ascending: false)
        
        dialogsToken = dialogsArray.observe({ [weak self] changes in
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
    
    func getUsersNotification() {
        let usersArray = RealmLoader.loadData(object: Friend())
        
        usersToken = usersArray.observe({ [weak self] changes in
            guard let view = self?.tableView else { return }
            switch changes {
            case .initial:
                view.reloadData()
            case .update(_, _, _, _):
                view.beginUpdates()
                view.reloadData()
                view.endUpdates()
            case .error(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    func getGroupsNotification() {
        let groupsArray = RealmLoader.loadData(object: Group())
        
        groupsToken = groupsArray.observe({ [weak self] changes in
            guard let view = self?.tableView else { return }
            switch changes {
            case .initial:
                view.reloadData()
            case .update(_, _, _, _):
                view.beginUpdates()
                view.reloadData()
                view.endUpdates()
            case .error(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    func addRefreshControl() {
        self.refreshControl?.addTarget(self, action: #selector(self.refreshView), for: .valueChanged)
    }
    
    @objc func refreshView(sender: AnyObject) {
        DispatchQueue.global(qos: .utility).async {
            DialogsRequests.getUserDialogs(userId: self.userId!, accessToken: self.accessToken!)
            DispatchQueue.main.async {
                self.refreshControl?.endRefreshing()
            }
        }
        getDialogsNotification()
        getUsersNotification()
        getGroupsNotification()
    }
}

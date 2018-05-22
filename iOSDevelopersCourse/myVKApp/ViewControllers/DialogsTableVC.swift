//
//  DialogsTableVC.swift
//  myVKApp
//
//  Created by Natalya on 25/03/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import RealmSwift
import Alamofire

class DialogsTableVC: UITableViewController {
    
    private lazy var dialogsArray: Results<Dialog> = {
        return RealmLoader.loadData(object: Dialog()).sorted(byKeyPath: "date", ascending: false)
    }()
    
    private lazy var  usersArray: Results<Friend> = {
        RealmLoader.loadData(object: Friend())
    }()
    
    private lazy var groupsArray: Results<Group> = {
        return RealmLoader.loadData(object: Group())
    }()
    
    var dialogsToken: NotificationToken?
    var usersToken: NotificationToken?
    var groupsToken: NotificationToken?
    
    var opQueue: OperationQueue = {
        let q = OperationQueue()
        q.qualityOfService = .userInteractive
        return q
    }()
    
    deinit {
        dialogsToken?.invalidate()
        usersToken?.invalidate()
        groupsToken?.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 55
        addRefreshControl()

        dialogsToken = getToken(dialogsArray, view: self.tableView)
        usersToken = Notifications.getTableViewTokenLight(usersArray, view: self.tableView)
        groupsToken = Notifications.getTableViewTokenLight(groupsArray, view: self.tableView)
        
        if dialogsArray.isEmpty {
            DialogsRequests.getUserDialogs(complition: nil)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dialogsArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! DialogsViewCell
        let dialog = dialogsArray[indexPath.row]
        let friendId = dialog.friendId
        
        cell.dialog = dialog
        
        guard dialog.chatId == 0,
            let user = friendId > 0 ? RealmRequests.getFriendData(friend: friendId.description) :
            RealmRequests.getGroupData(group: friendId.magnitude.description),
            let url = user.photoUrl
            else { return cell }
        let getImageOp = friendId > 0 ? GetCashedImage(url: url, folderName: .UserAvatars, userId: friendId.description) : GetCashedImage(url: url, folderName: .Groups, userId: friendId.magnitude.description)
        let cellReloadedOp = TableCellReloading(indexPath: indexPath, view: tableView, cell: cell, imageView: cell.messageFriendImage)
        cellReloadedOp.addDependency(getImageOp)
        opQueue.addOperation(getImageOp)
        OperationQueue.main.addOperation(cellReloadedOp)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showMessages", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showMessages" else { return }
        guard let destinationVC = segue.destination as? MessagesTableVC else { return }
        guard let friend = sender as? IndexPath else { return }
        let dialog = dialogsArray[friend.row]
        
        destinationVC.dialogId = dialog.id
        destinationVC.chatId = dialog.chatId
        setFriendNameForTitle(dialog: dialog, to: destinationVC)
    }
}

extension DialogsTableVC {
    
    private func addRefreshControl() {
        self.refreshControl?.addTarget(self, action: #selector(self.refreshView), for: .valueChanged)
    }
    
    @objc func refreshView(sender: AnyObject) {
        DialogsRequests.getUserDialogs(complition: nil)
            DispatchQueue.main.async { [weak self] in
                guard let s = self else { return }
                s.refreshControl?.endRefreshing()
                s.tableView.reloadData()
            }
    }
    
    private func setFriendNameForTitle(dialog: Dialog, to vc: UIViewController) {
        guard let controller = vc as? MessagesTableVC else { return }
        let friendId = dialog.chatId == 0 ? dialog.friendId : 0
        controller.friendId = friendId
        
        if dialog.title == ""  {
            guard let user = friendId > 0 ? RealmRequests.getFriendData(friend: friendId.description) :
                RealmRequests.getGroupData(group: friendId.magnitude.description)
                else { return }
            controller.friendName = user.name
            
            guard let url = user.photoUrl else { return }
            let getImageOp = friendId > 0 ? GetCashedImage(url: url, folderName: .UserAvatars, userId: friendId.description) : GetCashedImage(url: url, folderName: .Groups, userId: friendId.magnitude.description)
            
            getImageOp.completionBlock = {
                controller.friendImage = getImageOp.outputImage
            }
            opQueue.addOperation(getImageOp)
        } else  {
            controller.friendName = dialog.title
        }
    }
    
    private func getToken<T: Object>(_ array: Results<T>, view: UITableView?) -> NotificationToken {
        let arr = array.filter("readState == 0")
        let token = array.observe({ [weak view] changes in
            guard let view = view else { return }
            switch changes {
            case .initial:
                view.reloadData()
            case .update(_, let delete, let insert, let update):
                view.beginUpdates()
                view.deleteRows(at: delete.map({ IndexPath(row: $0, section: 0) }), with: .none)
                view.insertRows(at: insert.map({ IndexPath(row: $0, section: 0) }), with: .none)
                view.reloadRows(at: update.map({ IndexPath(row: $0, section: 0) }), with: .none)
                view.endUpdates()
                
                if arr.count > 0, let items = self.tabBarController?.tabBar.items {
                    items[1].title = "+ \(arr.count)"
                } else if let items = self.tabBarController?.tabBar.items {
                    items[1].title = ""
                }
            case .error(let error):
                print(error.localizedDescription)
            }
        })
        
        return token
    }
}

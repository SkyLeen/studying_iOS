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
    
    let accessToken = KeychainWrapper.standard.string(forKey: "accessToken")
    let userId =  KeychainWrapper.standard.string(forKey: "userId")
    
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
        DispatchQueue.global(qos: .utility).async {
            DialogsRequests.getUserDialogs(userId: self.userId!, accessToken: self.accessToken!)
        }
        
        dialogsToken = Notifications.getTableViewToken(dialogsArray, view: self.tableView)
        usersToken = Notifications.getTableViewTokenLight(usersArray, view: self.tableView)
        groupsToken = Notifications.getTableViewTokenLight(groupsArray, view: self.tableView)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dialogsArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! DialogsViewCell
        let dialog = dialogsArray[indexPath.row]
        let friendId = dialog.friendId
        
        cell.dialog = dialog
        
        guard let user = friendId > 0 ? RealmRequests.getFriendData(friend: friendId.description) :
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
        
        setFriendNameForTitle(dialog: dialog, to: destinationVC)
    }
}

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

class DialogsTableVC: UITableViewController {
    
    let accessToken = KeychainWrapper.standard.string(forKey: "accessToken")
    let userId =  KeychainWrapper.standard.string(forKey: "userId")
    
    lazy var dialogsArray: Results<Dialog> = {
        return RealmLoader.loadData(object: Dialog()).sorted(byKeyPath: "date", ascending: false)
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
        addRefreshControl()
        DispatchQueue.global(qos: .utility).async {
            DialogsRequests.getUserDialogs(userId: self.userId!, accessToken: self.accessToken!)
        }
        
        getDialogsNotification()
        getUsersNotification()
        getGroupsNotification()
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
        let cellReloadedOp = DialogCellReloading(indexPath: indexPath, view: tableView, cell: cell)
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
        guard let destinationVC = segue.destination as? DialogMessagesTableVC else { return }
        guard let friend = sender as? IndexPath else { return }
       
        destinationVC.friendId = dialogsArray[friend.row].friendId
    }
}

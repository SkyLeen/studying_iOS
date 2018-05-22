//
//  FriendsRequestsVC.swift
//  myVKApp
//
//  Created by Natalya on 16/05/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import RealmSwift

class FriendsRequestsVC: UITableViewController {

    var arrayRequests: Results<FriendRequest>?
    var opQueue: OperationQueue = {
        let q = OperationQueue()
        q.qualityOfService = .userInteractive
        return q
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 55
        arrayRequests = RealmLoader.loadData(object: FriendRequest()).sorted(byKeyPath: "lastName")
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = arrayRequests?.count
        return count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "requestedFriend", for: indexPath) as! FriendsRequestsViewCell

        if let userArray = arrayRequests  {
            let user = userArray[indexPath.row]
            cell.user = user
            
            guard let url = user.photoUrl else { return cell }
            let getImageOp = GetCashedImage(url: url, folderName: .Requests, userId: user.id)
            let cellReloadedOp = TableCellReloading(indexPath: indexPath, view: tableView, cell: cell, imageView: cell.friendImage)
            cellReloadedOp.addDependency(getImageOp)
            opQueue.addOperation(getImageOp)
            OperationQueue.main.addOperation(cellReloadedOp)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let editAction = UITableViewRowAction(style: .normal, title: "Accept") { (rowAction, indexPath) in
            if let userArray = self.arrayRequests  {
                let idFriend = userArray[indexPath.row].id
                print("accept request", idFriend)
            }
        }
        editAction.backgroundColor = .blue
        
        let deleteAction = UITableViewRowAction(style: .normal, title: "Delete") { (rowAction, indexPath) in
            if let userArray = self.arrayRequests  {
                let idFriend = userArray[indexPath.row].id
                print("delete request", idFriend)
            }
        }
        deleteAction.backgroundColor = .red
        
        return [editAction,deleteAction]
    }
}

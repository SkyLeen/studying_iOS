//
//  NewGroupsTableVC.swift
//  myVKApp
//
//  Created by Natalya on 24/02/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import RealmSwift

class AllGroupsTableVC: UITableViewController {
    
    let accessToken = KeychainWrapper.standard.string(forKey: "accessToken")
    let userId =  KeychainWrapper.standard.string(forKey: "userId")
    
    let searchBar = UISearchBar()
    lazy var allGroupsArray: Results<Group> = {
        return RealmLoader.loadData(object: Group()).filter("userId == ''")
    }()
    var filteredArray: Results<Group>!
    
    var isSearching = false
    var token: NotificationToken?
    
    var opQueue: OperationQueue = {
        let q = OperationQueue()
        q.qualityOfService = .userInteractive
        return q
    }()
    
    deinit {
        token?.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 55
        createSearchBar()
        GroupsRequests.getAllGroups(accessToken: self.accessToken!)
        token = Notifications.getTableViewToken(allGroupsArray, view: self.tableView)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rowsCount = isSearching ? filteredArray.count : allGroupsArray.count
        return rowsCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewGroupCell", for: indexPath) as! AllGroupsViewCell
        let group: Group!
        
        if isSearching {
            group = filteredArray[indexPath.row]
        } else {
            group = allGroupsArray[indexPath.row]
        }
        
        cell.group = group
        
        guard let url = group.photoGroupUrl else { return cell }
        let getImageOp = GetCashedImage(url: url, folderName: .Groups, userId: group.idGroup)
        let cellReloadedOp = TableCellReloading(indexPath: indexPath, view: tableView, cell: cell, imageView: cell.allGroupImageView)
        cellReloadedOp.addDependency(getImageOp)
        opQueue.addOperation(getImageOp)
        OperationQueue.main.addOperation(cellReloadedOp)
        
        return cell
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
}

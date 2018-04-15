//
//  NewGroupsTableVC.swift
//  myVKApp
//
//  Created by Natalya on 24/02/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit
import RealmSwift

class AllGroupsTableVC: UITableViewController {
    
    let searchBar = UISearchBar()
    lazy var allGroupsArray: Results<Group> = {
        return RealmLoader.loadData(object: Group()).sorted(byKeyPath: "followers", ascending: false)
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
        GroupsRequests.getAllGroups()
        token = Notifications.getTableViewTokenRows(allGroupsArray, view: self.tableView)
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
    
    private func createSearchBar() {
        searchBar.barTintColor = .white
        searchBar.tintColor = .white
        searchBar.showsCancelButton = true
        searchBar.keyboardType = .alphabet
        searchBar.placeholder = "Search"
        searchBar.returnKeyType = .done
        searchBar.delegate = self
        navigationItem.titleView = searchBar
    }
}

extension AllGroupsTableVC: UISearchBarDelegate {
    
    internal func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            isSearching = false
            searchBar.endEditing(true)
            tableView.reloadData()
        } else {
            isSearching = true
            self.loadGroupsData(filter: searchText)
            self.tableView.reloadData()
        }
    }
    
    internal func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    internal func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    private func loadGroupsData(filter: String = "") {
        let groups = RealmLoader.loadData(object: Group())
        
        switch isSearching {
        case true:
            filteredArray = groups.filter("nameGroup CONTAINS[c] '\(filter)'")
        case false:
            allGroupsArray = groups
        }
    }
}


//
//  NewGroupsTableVC.swift
//  myVKApp
//
//  Created by Natalya on 24/02/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit

class AllGroupsTableVC: UITableViewController {
    
    var accessToken = ""
    var userId = ""
    var groupsRequest = MethodRequest()
    
    let searchBar = UISearchBar()
    var allGroupsArray = [Group]()
    var filteredArray = [Group]()
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createSearchBar()
        
        groupsRequest.getAllGroups(accessToken: accessToken, completion: { [weak self] groups in
            self?.allGroupsArray = groups
            self?.tableView.reloadData()
        })
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rowsCount = isSearching ? filteredArray.count : allGroupsArray.count
        return rowsCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewGroupCell", for: indexPath) as! AllGroupsViewCell
        if isSearching {
            cell.allGroupNameLabel.text = filteredArray[indexPath.row].nameGroup
            cell.allGroupImageView.image = filteredArray[indexPath.row].photoGroup
            cell.allGroupFollowersCountLabel.text = "\(filteredArray[indexPath.row].followers) followers"
        } else {
            cell.allGroupNameLabel.text = allGroupsArray[indexPath.row].nameGroup
            cell.allGroupImageView.image = allGroupsArray[indexPath.row].photoGroup
            cell.allGroupFollowersCountLabel.text = "\(allGroupsArray[indexPath.row].followers) followers"
        }
        return cell
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
    
    func createSearchBar() {
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
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            isSearching = false
            searchBar.endEditing(true)
            tableView.reloadData()
        } else {
            isSearching = true
            
            groupsRequest.getGroupsSearch(accessToken: accessToken, searchText: searchText.lowercased(), completion: { [weak self] groups in
                self?.filteredArray = groups
                self?.tableView.reloadData()
            })
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}

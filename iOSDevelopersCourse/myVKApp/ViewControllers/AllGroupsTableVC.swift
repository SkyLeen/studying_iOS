//
//  NewGroupsTableVC.swift
//  myVKApp
//
//  Created by Natalya on 24/02/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class AllGroupsTableVC: UITableViewController {
    
    let accessToken = KeychainWrapper.standard.string(forKey: "accessToken")
    let userId =  KeychainWrapper.standard.string(forKey: "userId")
    var groupsRequest = GroupsRequests()
    
    let searchBar = UISearchBar()
    var allGroupsArray = [Group]()
    var filteredArray = [Group]()
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createSearchBar()
        
        groupsRequest.getAllGroups(accessToken: accessToken!) { [weak self] groups in
            self?.allGroupsArray = groups
            DispatchQueue.main.async {
                 self?.tableView.reloadData()
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rowsCount = isSearching ? filteredArray.count : allGroupsArray.count
        return rowsCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewGroupCell", for: indexPath) as! AllGroupsViewCell
        if isSearching {
            cell.group = filteredArray[indexPath.row]
        } else {
            cell.group = allGroupsArray[indexPath.row]
        }
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
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            isSearching = false
            searchBar.endEditing(true)
            tableView.reloadData()
        } else {
            isSearching = true
            groupsRequest.getGroupsSearch(accessToken: accessToken!, searchText: searchText.lowercased()) { [weak self] groups in
                self?.filteredArray = groups
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}

//
//  ExtAllGroupsTableVC.swift
//  myVKApp
//
//  Created by Natalya on 22/03/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import Foundation
import UIKit

extension AllGroupsTableVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
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
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    private func loadGroupsData(filter: String = "") {
        let groups = RealmLoader.loadData(object: Group()).filter("userId == %@", "")
        
        switch isSearching {
        case true:
            filteredArray = groups.filter("nameGroup CONTAINS[c] '\(filter)'")
        case false:
            allGroupsArray = groups
        }
    }
}

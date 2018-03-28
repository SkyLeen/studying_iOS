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

extension AllGroupsTableVC {
    
    func getNotification() {
        token = allGroupsArray.observe({ [weak self] changes in
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
}

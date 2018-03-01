//
//  NewGroupsTableVC.swift
//  myVKApp
//
//  Created by Natalya on 24/02/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit

class AllGroupsTableVC: UITableViewController {
    
    let searchBar = UISearchBar()
    let allGroupsArray = [
        (name: "Хабрахабр", photo: UIImage(named: "habrahabr.jpg"), followers: 726895),
        (name: "Just English", photo: UIImage(named: "justEnglish.jpg"), followers: 2135834),
        (name: "GeekBrains", photo: UIImage(named: "geekbrains.jpg"), followers: 112428),
        (name: "HappyWAY.travel", photo: UIImage(named: "happytravel.jpg"), followers: 1866),
        (name: "Намалевич", photo: UIImage(named: "namalevich.jpg"), followers: 749016),
        (name: "KudaGO", photo: UIImage(named: "kudago.jpg"), followers: 692030)]
    var filteredArray = [(name: String, photo: UIImage?, followers: Int)]()
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createSearchBar()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rowsCount = isSearching ? filteredArray.count : allGroupsArray.count
        return rowsCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewGroupCell", for: indexPath) as! AllGroupsViewCell
        if isSearching {
            cell.allGroupNameLabel.text = filteredArray[indexPath.row].name
            cell.allGroupImageView.image = filteredArray[indexPath.row].photo
            cell.allGroupFollowersCountLabel.text = "\(filteredArray[indexPath.row].followers) followers"
        } else {
            cell.allGroupNameLabel.text = allGroupsArray[indexPath.row].name
            cell.allGroupImageView.image = allGroupsArray[indexPath.row].photo
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
            filteredArray = allGroupsArray.filter({ text in
                return text.name.lowercased().contains(searchText.lowercased())
            })
            tableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}

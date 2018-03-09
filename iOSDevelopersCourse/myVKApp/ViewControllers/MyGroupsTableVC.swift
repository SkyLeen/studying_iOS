//
//  MyGroupsTableVC.swift
//  myVKApp
//
//  Created by Natalya on 24/02/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit

class MyGroupsTableVC: UITableViewController {

    var accessToken = ""
    var userId = ""
    var groupsRequest = MethodRequest()
    var myGroupsArray = [Group]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groupsRequest.getUserGroups(userId: userId, accessToken: accessToken) { [weak self] groups in
            self?.myGroupsArray = groups
            self?.tableView.reloadData()
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rowsCount = myGroupsArray.count
        return rowsCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as! MyGroupsViewCell
        cell.myGroupNameLabel.text = myGroupsArray[indexPath.row].nameGroup
        cell.myGroupImageView.image = myGroupsArray[indexPath.row].photoGroup
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showAllGroups" else { return }
        guard let destinationVC = segue.destination as? AllGroupsTableVC else { return }
        destinationVC.accessToken = accessToken
        destinationVC.userId = userId
    }
    
    @IBAction func addNewGroupPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "showAllGroups", sender: nil)
    }
    
    @IBAction func addNewGroup(segue: UIStoryboardSegue) {
        guard segue.identifier == "addNewGroup" else { return }
        guard let allGroupsVC = segue.source as? AllGroupsTableVC else { return }
        guard let cellNewGroup = allGroupsVC.tableView.indexPathForSelectedRow else { return }
        
        let isSearching = allGroupsVC.isSearching
        let newGroup = isSearching ? allGroupsVC.filteredArray[cellNewGroup.row] : allGroupsVC.allGroupsArray[cellNewGroup.row]
        
        guard !myGroupsArray.contains(where: { element in
            if case newGroup.nameGroup = element.nameGroup {
                return true
            } else {
                return false
            }
        }) else {
            present(AlertHelper().showAlert(withTitle: "Warning", message: "There is a such Group in the list"), animated: true)
            return
        }
        
        groupsRequest.joinGroup(accessToken: accessToken, idGroup: newGroup.idGroup) {
            self.viewDidLoad()
        }

    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let idGroup = myGroupsArray[indexPath.row].idGroup
        if editingStyle == .delete {
            groupsRequest.leaveGroup(accessToken: accessToken, idGroup: idGroup) {
                self.viewDidLoad()
            }
        }
    }
}

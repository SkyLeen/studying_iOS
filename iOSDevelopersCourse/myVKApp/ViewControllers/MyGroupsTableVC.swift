//
//  MyGroupsTableVC.swift
//  myVKApp
//
//  Created by Natalya on 24/02/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import RealmSwift

class MyGroupsTableVC: UITableViewController {

    private let accessToken = KeychainWrapper.standard.string(forKey: "accessToken")
    private let userId =  KeychainWrapper.standard.string(forKey: "userId")
    
    lazy var myGroupsArray: Results<Group> = {
        return Loader.loadData(object: Group()).filter("userId != ''")
    }()
    var token: NotificationToken?
    
    deinit {
        token?.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GroupsRequests.getUserGroups(userId: userId!, accessToken: accessToken!)
        getNotification()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rowsCount = myGroupsArray.count
        return rowsCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as! MyGroupsViewCell
        cell.group = myGroupsArray[indexPath.row]
        return cell
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
            present(AlertHelper.showAlert(withTitle: "Warning", message: "There is a such Group in the list"), animated: true)
            return
        }
        
        GroupsRequests.joinGroup(accessToken: accessToken!, idGroup: newGroup.idGroup)
        GroupsSaver.saveNewGroup(group: newGroup, userId: userId!)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let idGroup = myGroupsArray[indexPath.row].idGroup
        if editingStyle == .delete {
            GroupsRequests.leaveGroup(accessToken: accessToken!, idGroup: idGroup)
            Deleter.deleteData(object: myGroupsArray[indexPath.row])
        }
    }
}

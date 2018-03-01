//
//  MyGroupsTableVC.swift
//  myVKApp
//
//  Created by Natalya on 24/02/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit

class MyGroupsTableVC: UITableViewController {

    var myGroupsArray = [(name: String, photo: UIImage)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rowsCount = myGroupsArray.count
        return rowsCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as! MyGroupsViewCell
        cell.myGroupNameLabel.text = myGroupsArray[indexPath.row].name
        cell.myGroupImageView.image = myGroupsArray[indexPath.row].photo
        return cell
    }
    
    @IBAction func addNewGroupPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "showAllGroups", sender: nil)
    }
    
    @IBAction func addNewGroup(segue: UIStoryboardSegue) {
        guard segue.identifier == "addNewGroup" else { return }
        guard let allGroupsVC = segue.source as? AllGroupsTableVC else { return }
        guard let cellNewGroup = allGroupsVC.tableView.indexPathForSelectedRow else { return }
        
        let newGroup = allGroupsVC.AllGroupsArray[cellNewGroup.row]
        
        guard !myGroupsArray.contains(where: { element in
            if case newGroup.name = element.name {
                return true
            } else {
                return false
            }
        }) else {
            present(Functions().showAlert(withTitle: "Warning", message: "There is a such Group in the list"), animated: true)
            return
        }
        
        myGroupsArray.append((name: newGroup.name, photo: newGroup.photo) as! ((name: String, photo: UIImage)))
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            myGroupsArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

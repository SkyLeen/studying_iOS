//
//  SettingsTableVC.swift
//  myVKApp
//
//  Created by Natalya on 25/02/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit

class SettingsTableVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsViewCell

        cell.logOutLabel.text = "LogOut"

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showLogOutAlert()
    }
    
    func showLogOutAlert() {
        let alertController = UIAlertController(title: "Log out", message: "Are you sure to want to log out?", preferredStyle: .alert)
        
        let yesButton = UIAlertAction(title: "Yes", style: .default, handler: {
            action in self.performSegue(withIdentifier: "logOut", sender: self)
        })
        let noButton = UIAlertAction(title: "No", style: .cancel)
        
        alertController.addAction(noButton)
        alertController.addAction(yesButton)
        
        present(alertController, animated: true)
    }

}

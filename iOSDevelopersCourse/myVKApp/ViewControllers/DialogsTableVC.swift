//
//  DialogsTableVC.swift
//  myVKApp
//
//  Created by Natalya on 25/03/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import RealmSwift

class DialogsTableVC: UITableViewController {
    
    let accessToken = KeychainWrapper.standard.string(forKey: "accessToken")
    let userId =  KeychainWrapper.standard.string(forKey: "userId")
    
    var dialogsArray: Results<Dialog>!
    var token: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addRefreshControl()
        DispatchQueue.global(qos: .background).async {
            DialogsRequests.getUserDialogs(userId: self.userId!, accessToken: self.accessToken!)
        }
        
        getNotification()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dialogsArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! DialogsViewCell
        
        cell.dialog = dialogsArray[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showMessages", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showMessages" else { return }
        guard let destinationVC = segue.destination as? DialogMessagesTableVC else { return }
        guard let friend = sender as? IndexPath else { return }
        
        destinationVC.friendName = dialogsArray[friend.row].friendName ?? ""
        destinationVC.friendId = dialogsArray[friend.row].friendId
    }
}

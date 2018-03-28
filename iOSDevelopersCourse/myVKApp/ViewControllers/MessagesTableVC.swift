//
//  MessagesTableVC.swift
//  myVKApp
//
//  Created by Natalya on 25/03/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import RealmSwift

class MessagesTableVC: UITableViewController {
    
    let accessToken = KeychainWrapper.standard.string(forKey: "accessToken")
    let userId =  KeychainWrapper.standard.string(forKey: "userId")
    
    lazy var friendsDialogsArray: Results<Dialog> = {
        return RealmLoader.loadData(object: Dialog()).sorted(byKeyPath: "date", ascending: false)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.global(qos: .background).async {
            MessagesRequests.getUserDialogs(userId: self.userId!, accessToken: self.accessToken!)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsDialogsArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessagesViewCell
        
        cell.dialog = friendsDialogsArray[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showMessages", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showMessages" else { return }
        guard let destinationVC = segue.destination as? MessagesFriendTableVC else { return }
        guard let friend = sender as? IndexPath else { return }
        
        destinationVC.friendName = friendsDialogsArray[friend.row].friendName ?? ""
        destinationVC.friendId = friendsDialogsArray[friend.row].friendId
    }
}

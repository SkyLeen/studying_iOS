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
    
    var friendsMessageArray = [
        (friendId: 1, friend: "friendName1", message: "Message1Message1Message1 Message1Message1Message1Message1Message1 Message1Message1"),
        (friendId: 2, friend: "friendName2", message:"Message2  Message2Message2Message2 Message2 Message2Message2Message2Message2"),
        (friendId: 3, friend: "friendName3", message:"Message3Message3Message3Message3Message3Message3 Message3Message3Message3 Message3"),
        (friendId: 4, friend: "friendName4", message:"Message4 Message4 Message4 Message4 Message4 Message4 Message4 Message4 Message4"),
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsMessageArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessagesViewCell
        cell.messageFriendLabel.text = friendsMessageArray[indexPath.row].friend
        cell.messageTextLabel.text = friendsMessageArray[indexPath.row].message
        cell.messageFriendImage.image = UIImage(named: "friends")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showMessages", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showMessages" else { return }
        guard let destinationVC = segue.destination as? MessagesFriendTableVC else { return }
        guard let friend = sender as? IndexPath else { return }
        
        destinationVC.friendName = friendsMessageArray[friend.row].friend
        destinationVC.friendId = friendsMessageArray[friend.row].friendId
    }
}

//
//  ExtDialogMessageFriendVC.swift
//  myVKApp
//
//  Created by Natalya on 25/03/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import Foundation
import UIKit

extension DialogMessagesTableVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
}

extension DialogMessagesTableVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        
        if indexPath.row % 2 == 0  {
            let cellFriend = tableView.dequeueReusableCell(withIdentifier: "FriendMessageCell", for: indexPath) as! DialogFriendMessagesViewCell
            cellFriend.friendMessageLabel.text = "message"
            cellFriend.friendMessageImage.image = UIImage(named: "friends")
        
            cell = cellFriend
        }
        else {
            let cellUser = tableView.dequeueReusableCell(withIdentifier: "UserMessageCell", for: indexPath) as! DialogUserMessagesViewCell
            
            cellUser.friendMessageLabel.text = "message"
            cellUser.friendMessageImage.image = UIImage(named: "friends")
            
            cell = cellUser
        }
        
        return cell
    }
}

extension DialogMessagesTableVC {
    
    func sendMessage() {
        
    }
    
    func setMessageTableView() {
        if (self.messageTableView.contentSize.height > self.messageTableView.frame.size.height)
        {
            let offset  = CGPoint(x: 0, y: self.messageTableView.contentSize.height - self.messageTableView.frame.size.height)
            self.messageTableView.setContentOffset(offset, animated: true)
        }
    }
    
    func getTitle() {
        guard let user = friendId > 0 ? RealmRequests.getFriendData(friend: "\(friendId)") : RealmRequests.getGroupData(group: "\(friendId.magnitude)") else { return }
        navigationItem.title = user.name
    }
}



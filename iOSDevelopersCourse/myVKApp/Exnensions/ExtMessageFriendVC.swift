//
//  ExtMessageFriendVC.swift
//  myVKApp
//
//  Created by Natalya on 25/03/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import Foundation
import UIKit

extension MessagesFriendTableVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
}

extension MessagesFriendTableVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendMessageCell", for: indexPath) as! MessagesFriendViewCell
        
        let index = friendsMessageArray.index(where: {$0.friendId == friendId})
        
        cell.friendMessageLabel.text = friendsMessageArray[index!].message
        cell.friendMessageImage.image = UIImage(named: "friends")
        
        return cell
    }
}

extension MessagesFriendTableVC {

    
    func sendMessage() {
        
    }
    
    func setMessageTableView() {
        if (self.messageTableView.contentSize.height > self.messageTableView.frame.size.height)
        {
            let offset  = CGPoint(x: 0, y: self.messageTableView.contentSize.height - self.messageTableView.frame.size.height)
            self.messageTableView.setContentOffset(offset, animated: true)
        }
    }
}



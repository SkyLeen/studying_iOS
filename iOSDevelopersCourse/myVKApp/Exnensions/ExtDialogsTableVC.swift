//
//  ExtDialogsTableVC.swift
//  myVKApp
//
//  Created by Natalya on 29/03/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import RealmSwift
import UIKit

extension DialogsTableVC {
    
    func addRefreshControl() {
        self.refreshControl?.addTarget(self, action: #selector(self.refreshView), for: .valueChanged)
    }
    
    @objc func refreshView(sender: AnyObject) {
        DispatchQueue.global(qos: .utility).async {
            DialogsRequests.getUserDialogs(userId: self.userId!, accessToken: self.accessToken!)
            DispatchQueue.main.async { [weak self] in
                guard let s = self else { return }
                s.refreshControl?.endRefreshing()
                s.tableView.reloadData()
            }
        }
    }
    
    func setFriendNameForTitle(dialog: Dialog, to vc: UIViewController) {
        guard let controller = vc as? MessagesTableVC else { return }
        let friendId = dialog.friendId
        controller.friendId = friendId
        
        if dialog.title == ""  {
            guard let user = friendId > 0 ? RealmRequests.getFriendData(friend: friendId.description) :
                RealmRequests.getGroupData(group: friendId.magnitude.description)
                else { return }
            controller.friendName = user.name
            
            guard let url = user.photoUrl else { return }
            let getImageOp = friendId > 0 ? GetCashedImage(url: url, folderName: .UserAvatars, userId: friendId.description) : GetCashedImage(url: url, folderName: .Groups, userId: friendId.magnitude.description)
            
            getImageOp.completionBlock = {
                controller.friendImage = getImageOp.outputImage
            }
            opQueue.addOperation(getImageOp)
        } else  {
            controller.friendName = dialog.title
        }
    }
}

//
//  DialogsViewCell.swift
//  myVKApp
//
//  Created by Natalya on 25/03/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit

class DialogsViewCell: UITableViewCell {

    @IBOutlet weak var messageFriendImage: UIImageView!
    @IBOutlet weak var messageFriendLabel: UILabel!
    @IBOutlet weak var messageTextLabel: UILabel!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageDateLabel: UILabel!
    
    var dialog: Dialog? {
        didSet{
            setBackgroungColor()
            getDialogProperties()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ImageSettingsHelper.setImageLayersSettings(for: messageFriendImage, mode: .forAvatarImages)
    }
    
    private func setBackgroungColor() {
        
        if dialog?.readState == 0 && dialog?.out == 0 {
            messageView.backgroundColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
            messageTextLabel.backgroundColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
        } else if dialog?.readState == 0 && dialog?.out == 1 {
            messageTextLabel.backgroundColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
            messageView.backgroundColor = .white
        } else {
            messageTextLabel.backgroundColor = .white
            messageView.backgroundColor = .white
        }
    }
    
    private func getDialogProperties() {
        self.messageFriendLabel.text = nil
        self.messageTextLabel.text = nil
        self.messageDateLabel.text = nil

        if dialog?.attachments != "" {
            messageTextLabel.text = (dialog?.body)! + " [" + (dialog?.attachments)! + "]"
        } else {
             messageTextLabel.text = dialog?.body
        }
        messageDateLabel.text = Date(timeIntervalSince1970: (dialog?.date)!).formatted
        
        guard let friendId = dialog?.friendId,
            let user = friendId > 0 ? RealmRequests.getFriendData(friend: "\(friendId)") : RealmRequests.getGroupData(group: "\(friendId.magnitude)")
            else { return }
        messageFriendLabel.text = dialog?.title == "" ? user.name : dialog?.title

    }
}

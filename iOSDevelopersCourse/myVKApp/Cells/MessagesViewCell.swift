//
//  MessagesViewCell.swift
//  myVKApp
//
//  Created by Natalya on 25/03/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit

class MessagesViewCell: UITableViewCell {

    @IBOutlet weak var messageFriendImage: UIImageView!
    @IBOutlet weak var messageFriendLabel: UILabel!
    @IBOutlet weak var messageTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ImageSettingsHelper.setImageLayersSettings(for: messageFriendImage, mode: .forAvatarImages)
        
        messageFriendImage.image = UIImage(named: "friends")
        messageFriendLabel.text = "Friend"
        messageTextLabel.text = "First line of a message"
    }
}

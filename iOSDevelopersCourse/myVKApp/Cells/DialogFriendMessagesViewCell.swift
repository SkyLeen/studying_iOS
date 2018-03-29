//
//  DialogFriendMessagesViewCell.swift
//  myVKApp
//
//  Created by Natalya on 25/03/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit

class DialogFriendMessagesViewCell: UITableViewCell {


    @IBOutlet weak var friendMessageImage: UIImageView!
    @IBOutlet weak var friendMessageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ImageSettingsHelper.setImageLayersSettings(for: friendMessageImage, mode: .forAvatarImages)
        friendMessageLabel.layer.cornerRadius = 10
    }
}

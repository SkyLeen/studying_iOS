//
//  FriendsRequestsViewCell.swift
//  myVKApp
//
//  Created by Natalya on 16/05/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit

class FriendsRequestsViewCell: UITableViewCell {

    @IBOutlet weak var friendImage: UIImageView!
    @IBOutlet weak var nameFriend: UILabel!
    
    var user: FriendRequest? {
        didSet {
            nameFriend.text = user?.name
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ImageSettingsHelper.setImageLayersSettings(for: friendImage, mode: .forAvatarImages)
    }
}

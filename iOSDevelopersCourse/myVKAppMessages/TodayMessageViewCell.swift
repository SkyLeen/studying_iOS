//
//  TodayMessageViewCell.swift
//  myVKAppMessages
//
//  Created by Natalya on 27/05/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit

class TodayMessageViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dialogImage: UIImageView!
    @IBOutlet weak var friendLabel: UILabel!
    
    var dialog: Dialog? {
        didSet {
            guard let friendId = dialog?.friendId,
                let user = friendId > 0 ? RealmRequests.getFriendData(friend: "\(friendId)") : RealmRequests.getGroupData(group: "\(friendId.magnitude)")
                else { return }
            friendLabel.text = dialog?.title == "" ? user.name : dialog?.title
            friendLabel.numberOfLines = 0
            friendLabel.lineBreakMode = .byWordWrapping
            friendLabel.sizeToFit()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ImageSettingsHelper.setImageLayersSettings(for: dialogImage, mode: .forAvatarImages)
    }
}

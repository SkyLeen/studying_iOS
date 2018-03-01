//
//  MyFriendsViewCell.swift
//  myVKApp
//
//  Created by Natalya on 24/02/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit

class MyFriendsViewCell: UITableViewCell {

    @IBOutlet weak var friendNameLabel: UILabel!
    @IBOutlet weak var friendImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ImageSettingsHelper().setImageLayersSettings(for: friendImageView, mode: .forAvatarImages)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}

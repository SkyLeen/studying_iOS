//
//  AllGroupsViewCell.swift
//  myVKApp
//
//  Created by Natalya on 24/02/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit

class AllGroupsViewCell: UITableViewCell {
    
    @IBOutlet weak var allGroupNameLabel: UILabel!
    @IBOutlet weak var allGroupImageView: UIImageView!
    @IBOutlet weak var allGroupFollowersCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ImageSettingsHelper().setImageLayersSettings(for: allGroupImageView, mode: .forAvatarImages)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

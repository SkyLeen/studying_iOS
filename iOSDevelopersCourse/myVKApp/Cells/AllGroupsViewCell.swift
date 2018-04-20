//
//  AllGroupsViewCell.swift
//  myVKApp
//
//  Created by Natalya on 24/02/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit

class AllGroupsViewCell: UITableViewCell {
    
    @IBOutlet private weak var allGroupNameLabel: UILabel!
    @IBOutlet weak var allGroupImageView: UIImageView!
    @IBOutlet private weak var allGroupFollowersCountLabel: UILabel!
    
    var task: URLSessionTask?
    var group: Group? {
        didSet {
            allGroupNameLabel.text = group?.nameGroup
            
            guard let followers = group?.followers else { return }
            allGroupFollowersCountLabel.text = "\(followers.withSeparator) followers"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ImageSettingsHelper.setImageLayersSettings(for: allGroupImageView, mode: .forAvatarImages)
    }
}

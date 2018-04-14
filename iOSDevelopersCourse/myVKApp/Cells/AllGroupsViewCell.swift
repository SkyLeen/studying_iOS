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
    
    let insets: CGFloat = 5
    
    var group: Group? {
        didSet {
            allGroupNameLabel.text = group?.nameGroup
            setImageFrame()
            setNameLabelFrame()
            
            guard let followers = group?.followers else { return }
            allGroupFollowersCountLabel.text = "\(followers.withSeparator) followers"
            setFollowersFrame()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cancelAutoConstraints()
        ImageSettingsHelper.setImageLayersSettings(for: allGroupImageView, mode: .forAvatarImages)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setImageFrame()
        setNameLabelFrame()
        setFollowersFrame()
    }
}

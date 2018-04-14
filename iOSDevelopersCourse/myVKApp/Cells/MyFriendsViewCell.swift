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
    
    let insets: CGFloat = 5
    
    var user: Friend? {
        didSet {
            friendNameLabel.text = user?.name
            setImageFrame()
            setLabelFrame()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cancelAutoConstraints()
        ImageSettingsHelper.setImageLayersSettings(for: friendImageView, mode: .forAvatarImages)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setImageFrame()
        setLabelFrame()
    }
}

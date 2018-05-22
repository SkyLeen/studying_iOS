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
    @IBOutlet weak var stateImage: UIImageView!
    
    let color = UIColor(red: 239/255, green: 194/255, blue: 68/255, alpha: 1.0)
    var user: Friend? {
        didSet {
            friendNameLabel.text = user?.name
            stateImage.backgroundColor = user?.online == 0 ? .white : color
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ImageSettingsHelper.setImageLayersSettings(for: friendImageView, mode: .forAvatarImages)
        stateImage.layer.cornerRadius = stateImage.frame.width/2
    }
}

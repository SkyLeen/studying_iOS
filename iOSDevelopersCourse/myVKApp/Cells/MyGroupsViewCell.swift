//
//  MyGroupsViewCell.swift
//  myVKApp
//
//  Created by Natalya on 24/02/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit

class MyGroupsViewCell: UITableViewCell {
    
    @IBOutlet weak var myGroupNameLabel: UILabel!
    @IBOutlet weak var myGroupImageView: UIImageView!
    
     let insets: CGFloat = 5
    
    var group: Group? {
        didSet {
            myGroupNameLabel.text = group?.nameGroup
            setImageFrame()
            setLabelFrame()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cancelAutoConstraints()
        ImageSettingsHelper.setImageLayersSettings(for: myGroupImageView, mode: .forAvatarImages)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setImageFrame()
        setLabelFrame()
    }
}

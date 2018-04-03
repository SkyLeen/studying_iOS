//
//  MyGroupsViewCell.swift
//  myVKApp
//
//  Created by Natalya on 24/02/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit

class MyGroupsViewCell: UITableViewCell {
    
    @IBOutlet private weak var myGroupNameLabel: UILabel!
    @IBOutlet weak var myGroupImageView: UIImageView!
    
    var task: URLSessionTask?
    var group: Group? {
        didSet {
            myGroupNameLabel.text = group?.nameGroup
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ImageSettingsHelper.setImageLayersSettings(for: myGroupImageView, mode: .forAvatarImages)
    }
}

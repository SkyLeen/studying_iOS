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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ImageSettingsHelper.setImageLayersSettings(for: dialogImage, mode: .forAvatarImages)
    }
}

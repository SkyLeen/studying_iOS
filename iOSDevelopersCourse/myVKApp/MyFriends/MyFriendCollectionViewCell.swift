//
//  MyFriendCollectionViewCell.swift
//  myVKApp
//
//  Created by Natalya on 24/02/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit

class MyFriendCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var myFriendPhoto: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        layer.cornerRadius = 16
        layer.masksToBounds = true
    }
    
}

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
        cancelAutoConstraints()
        ImageSettingsHelper.setImageLayersSettings(for: myFriendPhoto, mode: .forPhotos)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setImageFrame()
    }
}

extension MyFriendCollectionViewCell {
    
    private func cancelAutoConstraints() {
        myFriendPhoto.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setImageFrame() {
        let side: CGFloat = self.frame.width
        let size = CGSize(width: ceil(side), height: ceil(side))
        
        let position: CGFloat = 0.0
        let origin = CGPoint(x: position, y: position)
        let frame = CGRect(origin: origin, size: size)
        
        myFriendPhoto.frame = frame
    }
}

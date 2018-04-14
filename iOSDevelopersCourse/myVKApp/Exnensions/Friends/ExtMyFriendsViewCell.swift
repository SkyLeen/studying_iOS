//
//  ExtMyFriendsViewCell.swift
//  myVKApp
//
//  Created by Natalya on 12/04/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit

extension MyFriendsViewCell {
    
    func cancelAutoConstraints() {
        [friendImageView, friendNameLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    func setImageFrame() {
        let frame = Layers.getAvatarImageFrame(insets: insets)
        friendImageView.frame = frame
    }
    
    func setLabelFrame() {
        let insetsX = insets + friendImageView.frame.width + insets
        let labelSize = Layers.getLabelSize(text: friendNameLabel.text!, font: friendNameLabel.font, in: self, insets: insetsX)
        let insetsY = friendImageView.frame.midY - labelSize.height / 2
        
        let frame = Layers.getLabelFrame(fromX: insetsX, fromY: insetsY, labelSize: labelSize)
        friendNameLabel.frame = frame
        friendNameLabel.sizeToFit()
    }
}

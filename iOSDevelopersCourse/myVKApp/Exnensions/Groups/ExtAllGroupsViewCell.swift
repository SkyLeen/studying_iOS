//
//  ExtAllGroupsViewCell.swift
//  myVKApp
//
//  Created by Natalya on 12/04/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit

extension AllGroupsViewCell {
    
    func cancelAutoConstraints() {
        allGroupImageView.translatesAutoresizingMaskIntoConstraints = false
        allGroupNameLabel.translatesAutoresizingMaskIntoConstraints = false
        allGroupFollowersCountLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setImageFrame() {
        let frame = Layers.getAvatarImageFrame(insets: insets)
        allGroupImageView.frame = frame
    }
    
    func setNameLabelFrame() {
        let insetsX = insets + allGroupImageView.frame.width + insets
        let labelSize = Layers.getLabelSize(text: allGroupNameLabel.text!, font: allGroupNameLabel.font, in: self, insets: insetsX)
        let frame = Layers.getLabelFrame(fromX: insetsX, fromY: insets, labelSize: labelSize)
       
        allGroupNameLabel.frame = frame
    }
    
    func setFollowersFrame() {
        let insetsX = insets + allGroupImageView.frame.width + insets
        let insetsY = allGroupNameLabel.frame.maxY + insets
        let labelSize = Layers.getLabelSize(text: allGroupFollowersCountLabel.text!, font: allGroupFollowersCountLabel.font, in: self, insets: insetsX)
        
        let frame = Layers.getLabelFrame(fromX: insetsX, fromY: insetsY, labelSize: labelSize)
       
        allGroupFollowersCountLabel.frame = frame
    }
}

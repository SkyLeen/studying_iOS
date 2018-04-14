//
//  ExtMyGroupsViewCell.swift
//  myVKApp
//
//  Created by Natalya on 12/04/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit

extension MyGroupsViewCell {
    
    func cancelAutoConstraints() {
        [myGroupImageView, myGroupNameLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    func setImageFrame() {
        let frame = Layers.getAvatarImageFrame(insets: insets)
        myGroupImageView.frame = frame
    }
    
    func setLabelFrame() {
        let insetsX = insets + myGroupImageView.frame.width + insets
        let labelSize = Layers.getLabelSize(text: myGroupNameLabel.text!, font: myGroupNameLabel.font, in: self, insets: insetsX)
        let insetsY = myGroupImageView.frame.midY - labelSize.height / 2
        
        let frame = Layers.getLabelFrame(fromX: insetsX, fromY: insetsY, labelSize: labelSize)
        
        myGroupNameLabel.frame = frame
    }
}

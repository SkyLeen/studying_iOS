//
//  AllGroupsViewCell.swift
//  myVKApp
//
//  Created by Natalya on 24/02/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit

class AllGroupsViewCell: UITableViewCell {
    
    @IBOutlet weak var allGroupNameLabel: UILabel!
    @IBOutlet weak var allGroupImageView: UIImageView!
    @IBOutlet weak var allGroupFollowersCountLabel: UILabel!
    
    let insets: CGFloat = 5
    
    var group: Group? {
        didSet {
            allGroupNameLabel.text = group?.nameGroup
            setImageFrame()
            setNameLabelFrame()
            
            guard let followers = group?.followers else { return }
            allGroupFollowersCountLabel.text = "\(followers.withSeparator) followers"
            setFollowersFrame()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cancelAutoConstraints()
        ImageSettingsHelper.setImageLayersSettings(for: allGroupImageView, mode: .forAvatarImages)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setImageFrame()
        setNameLabelFrame()
        setFollowersFrame()
    }
}

extension AllGroupsViewCell {
    
    private func cancelAutoConstraints() {
        [allGroupImageView, allGroupNameLabel, allGroupFollowersCountLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setImageFrame() {
        let frame = Layers.getAvatarImageFrame(insets: insets)
        allGroupImageView.frame = frame
    }
    
    private func setNameLabelFrame() {
        let insetsX = insets + allGroupImageView.frame.width + insets
        let labelSize = Layers.getLabelSize(text: allGroupNameLabel.text!, font: allGroupNameLabel.font, in: self, insets: insetsX)
        let frame = Layers.getLabelFrame(fromX: insetsX, fromY: insets, labelSize: labelSize)
        
        allGroupNameLabel.frame = frame
    }
    
    private func setFollowersFrame() {
        let insetsX = insets + allGroupImageView.frame.width + insets
        let insetsY = allGroupNameLabel.frame.maxY + insets
        let labelSize = Layers.getLabelSize(text: allGroupFollowersCountLabel.text!, font: allGroupFollowersCountLabel.font, in: self, insets: insetsX)
        
        let frame = Layers.getLabelFrame(fromX: insetsX, fromY: insetsY, labelSize: labelSize)
        
        allGroupFollowersCountLabel.frame = frame
    }
}

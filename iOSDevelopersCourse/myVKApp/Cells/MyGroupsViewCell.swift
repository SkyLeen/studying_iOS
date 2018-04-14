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

extension MyGroupsViewCell {
    
    private func cancelAutoConstraints() {
        [myGroupImageView, myGroupNameLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setImageFrame() {
        let frame = Layers.getAvatarImageFrame(insets: insets)
        myGroupImageView.frame = frame
    }
    
    private func setLabelFrame() {
        let insetsX = insets + myGroupImageView.frame.width + insets
        let labelSize = Layers.getLabelSize(text: myGroupNameLabel.text!, font: myGroupNameLabel.font, in: self, insets: insetsX)
        let insetsY = myGroupImageView.frame.midY - labelSize.height / 2
        
        let frame = Layers.getLabelFrame(fromX: insetsX, fromY: insetsY, labelSize: labelSize)
        
        myGroupNameLabel.frame = frame
    }
}

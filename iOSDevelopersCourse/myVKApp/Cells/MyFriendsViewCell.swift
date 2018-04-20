//
//  MyFriendsViewCell.swift
//  myVKApp
//
//  Created by Natalya on 24/02/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit

class MyFriendsViewCell: UITableViewCell {

    @IBOutlet weak var friendNameLabel: UILabel!
    @IBOutlet weak var friendImageView: UIImageView!
    
    let insets: CGFloat = 5
    
    var user: Friend? {
        didSet {
            friendNameLabel.text = user?.name
            setImageFrame()
            setLabelFrame()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cancelAutoConstraints()
        ImageSettingsHelper.setImageLayersSettings(for: friendImageView, mode: .forAvatarImages)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setImageFrame()
        setLabelFrame()
    }
}

extension MyFriendsViewCell {
    
    private func cancelAutoConstraints() {
        [friendImageView, friendNameLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setImageFrame() {
        let frame = Layers.getAvatarImageFrame(insets: insets)
        friendImageView.frame = frame
    }
    
    private func setLabelFrame() {
        let insetsX = insets + friendImageView.frame.width + insets
        let labelSize = Layers.getLabelSize(text: friendNameLabel.text!, font: friendNameLabel.font, in: self, insets: insetsX)
        let insetsY = friendImageView.frame.midY - labelSize.height / 2
        
        let frame = Layers.getLabelFrame(fromX: insetsX, fromY: insetsY, labelSize: labelSize)
        friendNameLabel.frame = frame
        friendNameLabel.sizeToFit()
    }
}

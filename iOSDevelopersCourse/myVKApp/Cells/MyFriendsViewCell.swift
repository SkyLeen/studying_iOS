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
    @IBOutlet weak var stateImage: UIImageView!
    
    let insets: CGFloat = 5
    let color = UIColor(red: 239/255, green: 194/255, blue: 68/255, alpha: 1.0)
    var user: Friend? {
        didSet {
            friendNameLabel.text = user?.name
            stateImage.backgroundColor = user?.online == 0 ? .white : color
            setImageFrame()
            setLabelFrame()
            setStateImage()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cancelAutoConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setImageFrame()
        setLabelFrame()
        setStateImage()
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
        ImageSettingsHelper.setImageLayersSettings(for: friendImageView, mode: .forAvatarImages)
    }
    
    private func setLabelFrame() {
        let insetsX = insets + friendImageView.frame.width + insets
        let labelSize = Layers.getLabelSize(text: friendNameLabel.text!, font: friendNameLabel.font, in: self, insets: insetsX + insets + stateImage.frame.width)
        let insetsY = friendImageView.frame.midY - labelSize.height / 2
        
        let frame = Layers.getLabelFrame(fromX: insetsX, fromY: insetsY, labelSize: labelSize)
        friendNameLabel.frame = frame
        friendNameLabel.sizeToFit()
    }
    
    private func setStateImage() {
        let rectSide: CGFloat = 7
        let size = CGSize(width: ceil(rectSide), height: ceil(rectSide))
        
        let insetsX = self.frame.width - insets * 6
        let insetsY = friendImageView.frame.midY - size.height / 2
        
        let origin = CGPoint(x: insetsX, y: insetsY)
        let frame = CGRect(origin: origin, size: size)
        
        stateImage.frame = frame
        stateImage.layer.cornerRadius = stateImage.frame.width/2
    }
}

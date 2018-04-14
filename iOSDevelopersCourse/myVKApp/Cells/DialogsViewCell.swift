//
//  DialogsViewCell.swift
//  myVKApp
//
//  Created by Natalya on 25/03/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit

class DialogsViewCell: UITableViewCell {

    @IBOutlet weak var messageFriendImage: UIImageView!
    @IBOutlet weak var messageFriendLabel: UILabel!
    @IBOutlet weak var messageTextLabel: UILabel!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageDateLabel: UILabel!
    
    let insets: CGFloat = 5
    
    var dialog: Dialog? {
        didSet{
            setBackgroungColor()
            getDialogProperties()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cancelAutoConstraints()
        ImageSettingsHelper.setImageLayersSettings(for: messageFriendImage, mode: .forAvatarImages)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setImageFrame()
        setDateLabelFrame()
        setNameLabelFrame()
        setTextLabelFrame()
    }
}

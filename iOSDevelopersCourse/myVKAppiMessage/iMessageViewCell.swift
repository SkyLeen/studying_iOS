//
//  iMessageViewCell.swift
//  myVKAppiMessage
//
//  Created by Natalya on 30/05/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit

class iMessageViewCell: UITableViewCell {
    @IBOutlet weak var friendLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var newsTextLabel: UILabel!
    @IBOutlet weak var newsImage: UIImageView!
    
    var news: News? {
        didSet {
            friendLabel.text = news?.author
            dateLabel.text = Date(timeIntervalSince1970: (news?.date)!).formatted
            newsTextLabel.text = news?.text
            newsImage.image = nil
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ImageSettingsHelper.setImageLayersSettings(for: newsImage, mode: .forPhotos)
    }
}

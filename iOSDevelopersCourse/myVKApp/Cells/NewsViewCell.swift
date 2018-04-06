//
//  NewsViewCell.swift
//  myVKApp
//
//  Created by Natalya on 24/03/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit

class NewsViewCell: UITableViewCell {

    @IBOutlet weak var authorImage: UIImageView!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var newsLabel: UILabel!
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var repostsLabel: UILabel!
    @IBOutlet weak var viewsLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var news: News? {
        didSet {
            authorNameLabel.text = news?.author
            newsLabel.text = news?.text
            likesLabel.text = news?.likesCount.withSeparator
            commentsLabel.text = news?.commentsCount.withSeparator
            repostsLabel.text = news?.repostsCount.withSeparator
            viewsLabel.text = news?.viewsCount.withSeparator
            
            guard let date = news?.date else { return }
            dateLabel.text = Date(timeIntervalSince1970: date).formatted
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ImageSettingsHelper.setImageLayersSettings(for: authorImage, mode: .forAvatarImages)
    }
}


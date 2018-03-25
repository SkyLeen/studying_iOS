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
    @IBOutlet weak var watchingsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ImageSettingsHelper.setImageLayersSettings(for: authorImage, mode: .forAvatarImages)
        
        let canvasSize = newsImage.bounds.size.width
        let photo = UIImage(named:"newsPhoto")?.resizeWithWidth(width: canvasSize)
        let text = """
                        Some news. Bla-bla-bla-bla-bla-bla-bla-bla-bla-bla-bla-bla-bla-bla-bla-bla-bla-bla-bla-bla-bla-bla-bla-bla-bla-bla-bla. Bla-bla-bla-bla-bla-bla-bla-bla-bla-bla-bla-bla-bla-bla-bla-bla-bla-bla-bla-bla-bla-bla-bla-bla-bla-bla-bla. Bla-bla-bla-bla-bla-bla-bla-bla-bla-bla-bla-bla-bla-bla-bla-bla-bla-bla-bla-bla-bla-bla-bla-bla-bla-bla-bla
                        """

        authorImage.image = UIImage(named: "friends")
        authorNameLabel.text = "News` author"
        newsLabel.text = text
        newsImage.image = photo
        likesLabel.text = "100500"
        commentsLabel.text = "150"
        repostsLabel.text = "1000"
        watchingsLabel.text = "200000"
    }
}


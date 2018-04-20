//
//  NewsViewCell.swift
//  myVKApp
//
//  Created by Natalya on 10/04/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit

class NewsViewCell: UITableViewCell {
    
    @IBOutlet weak var authorImage: UIImageView!
    @IBOutlet weak var authorNameLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var newsLabel: UILabel!
    @IBOutlet weak var newsImage: UIImageView!
    
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var likesImage: UIImageView!
    @IBOutlet weak var likesLabel: UILabel!
    
    @IBOutlet weak var commentImage: UIImageView!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var repostsImage: UIImageView!
    @IBOutlet weak var repostsLabel: UILabel!
    
    @IBOutlet weak var viewsImage: UIImageView!
    @IBOutlet weak var viewsLabel: UILabel!
    
    weak var delegate: CellHeightDelegate?
    var index: IndexPath?
    var attachments: [NewsAttachments]?
    
    let insets: CGFloat = 5
    let insetsBtwElements: CGFloat = 5
    
    var news: News? {
        didSet {
            setAvatarImageFrame()
            
            authorNameLabel.text = news?.author
            setAuthorLabelFrame()
            
            dateLabel.text = Date(timeIntervalSince1970: (news?.date)!).formatted
            setDateLabelFrame()
            
            newsLabel.text = news?.text
            setNewsLabelFrame()
            newsImage.image = nil
            
            likesLabel.text = news?.likesCount.withSeparator
            commentsLabel.text = news?.commentsCount.withSeparator
            repostsLabel.text = news?.repostsCount.withSeparator
            viewsLabel.text = news?.viewsCount.withSeparator
            setFooterViewFrame()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cancelAutoConstraints()
        ImageSettingsHelper.setImageLayersSettings(for: authorImage, mode: .forAvatarImages)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setAvatarImageFrame()
        setAuthorLabelFrame()
        setDateLabelFrame()
        setNewsLabelFrame()
        setNewsImageFrame()
        setFooterViewFrame()
    }
}


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

extension NewsViewCell {
    
    private func cancelAutoConstraints() {
        [
            authorImage, authorNameLabel, dateLabel,newsLabel, newsImage,
            footerView, likesImage,likesLabel, commentImage, commentsLabel,
            repostsImage,repostsLabel, viewsImage, viewsLabel
            ].forEach {
                $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setAvatarImageFrame() {
        let frame = Layers.getAvatarImageFrame(insets: insets)
        authorImage.frame = frame
    }
    
    private func setAuthorLabelFrame() {
        let insetsX = insets + self.bounds.origin.x + authorImage.bounds.width + insetsBtwElements
        let insetsY = insets
        let labelSize = Layers.getLabelSize(text: authorNameLabel.text!, font: authorNameLabel.font, in: self, insets: insetsX)
        let frame = Layers.getLabelFrame(fromX: insetsX, fromY: insetsY, labelSize: labelSize)
        
        authorNameLabel.frame = frame
        authorNameLabel.numberOfLines = 0
        authorNameLabel.lineBreakMode = .byWordWrapping
        authorNameLabel.sizeToFit()
    }
    
    private func setDateLabelFrame() {
        let insetsX = self.bounds.origin.x + authorImage.bounds.width + insets + insetsBtwElements
        let insetsY = authorNameLabel.frame.height + insetsBtwElements
        let labelSize = Layers.getLabelSize(text: dateLabel.text!, font: dateLabel.font, in: self, insets: insetsX)
        
        let frame = Layers.getLabelFrame(fromX: insetsX, fromY: insetsY, labelSize: labelSize)
        
        dateLabel.frame = frame
    }
    
    private func setNewsLabelFrame() {
        let insetsX = insets
        var insetsY = insets
        let labelSize = Layers.getLabelSize(text: newsLabel.text!, font: newsLabel.font, in: self, insets: insetsX)
        let labelsHeight = dateLabel.bounds.maxY + authorNameLabel.bounds.maxY + insetsBtwElements
        
        if authorImage.bounds.maxY >= labelsHeight {
            insetsY += authorImage.bounds.maxY + insetsBtwElements
        } else {
            insetsY += labelsHeight + insetsBtwElements
        }
        
        let frame = Layers.getLabelFrame(fromX: insetsX, fromY: insetsY, labelSize: labelSize)
        
        newsLabel.frame = frame
        newsLabel.sizeToFit()
    }
    
    func setNewsImageFrame() {
        if let attachments = attachments, attachments.isEmpty {
            newsImage.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
            return
        }
        
        let width = self.bounds.width
        let height = self.bounds.width + insetsBtwElements
        let imageBlock = CGSize(width: width, height: height)
        
        let positionX = self.frame.origin.x
        let positionY = newsLabel.frame.origin.y + newsLabel.bounds.height + insetsBtwElements
        let origin = CGPoint(x: positionX, y: positionY)
        let frame = CGRect(origin: origin, size: imageBlock)
        
        newsImage.frame = frame
    }
    
    private func setFooterViewFrame() {
        let maxWidth = self.bounds.width - insets * 2
        let maxHeight: CGFloat = 20
        let viewSize = CGSize(width: maxWidth, height: maxHeight)
        
        let positionX = insets
        let positionY = self.frame.height - insets - viewSize.height
        let origin = CGPoint(x: positionX, y: positionY)
        let frame = CGRect(origin: origin, size: viewSize)
        
        footerView.frame = frame
        
        setLikesImages()
        setLikesLabel()
        setCommentsImages()
        setCommentsLabel()
        setRepostsImages()
        setRepostsLabel()
        setViewsLabel()
        setViewsImages()
    }
    
    func updateHeight() {
        let height = getCellHeight()
        guard let index = index
            , self.bounds.height != height else { return }
        delegate?.setCellHeight(height, at: index, cell: self)
    }
    
    private func setLikesImages() {
        let rectSide: CGFloat = 20
        let size = CGSize(width: rectSide, height: rectSide)
        
        let positionX = footerView.bounds.origin.x
        let positionY = footerView.bounds.origin.y
        let origin = CGPoint(x: positionX, y: positionY)
        let frame = CGRect(origin: origin, size: size)
        
        likesImage.frame = frame
    }
    
    private func setLikesLabel() {
        let insetsX = likesImage.bounds.width + insetsBtwElements
        let insetsY = footerView.bounds.origin.y
        let labelSize = Layers.getLabelSize(text: likesLabel.text!, font: likesLabel.font, in: self, insets: insetsX)
        
        let frame = Layers.getLabelFrame(fromX: insetsX, fromY: insetsY, labelSize: labelSize)
        
        likesLabel.frame = frame
    }
    
    private func setCommentsImages() {
        let rectSide: CGFloat = 20
        let size = CGSize(width: rectSide, height: rectSide)
        
        let positionX = likesImage.bounds.width + insetsBtwElements + likesLabel.bounds.width + insetsBtwElements
        let positionY = footerView.bounds.origin.y
        let origin = CGPoint(x: positionX, y: positionY)
        let frame = CGRect(origin: origin, size: size)
        
        commentImage.frame = frame
    }
    
    private func setCommentsLabel() {
        let insetsX = likesImage.bounds.width + insetsBtwElements + likesLabel.bounds.width + insetsBtwElements + commentImage.bounds.width + insetsBtwElements
        let insetsY = footerView.bounds.origin.y
        
        let labelSize = Layers.getLabelSize(text: commentsLabel.text!, font: commentsLabel.font, in: self, insets: insetsX)
        
        let frame = Layers.getLabelFrame(fromX: insetsX, fromY: insetsY, labelSize: labelSize)
        
        commentsLabel.frame = frame
    }
    
    private func setRepostsImages() {
        let rectSide: CGFloat = 20
        let size = CGSize(width: rectSide, height: rectSide)
        
        let positionX = likesImage.bounds.width + insetsBtwElements + likesLabel.bounds.width + insetsBtwElements + commentImage.bounds.width + insetsBtwElements + commentsLabel.bounds.width + insetsBtwElements
        let positionY = footerView.bounds.origin.y
        let origin = CGPoint(x: positionX, y: positionY)
        let frame = CGRect(origin: origin, size: size)
        
        repostsImage.frame = frame
    }
    
    private func setRepostsLabel() {
        let insetsX = likesImage.bounds.width + insetsBtwElements + likesLabel.bounds.width + insetsBtwElements + commentImage.bounds.width + insetsBtwElements + commentsLabel.bounds.width + insetsBtwElements + repostsImage.bounds.width + insetsBtwElements
        let insetsY = footerView.bounds.origin.y
        
        let labelSize = Layers.getLabelSize(text: repostsLabel.text!, font: repostsLabel.font, in: self, insets: insetsX)
        
        let frame = Layers.getLabelFrame(fromX: insetsX, fromY: insetsY, labelSize: labelSize)
        
        repostsLabel.frame = frame
    }
    
    private func setViewsLabel() {
        let labelSize = Layers.getLabelSize(text: viewsLabel.text!, font: viewsLabel.font, in: self, insets: CGFloat(0.0))
        let insetsX = footerView.bounds.width - labelSize.width
        let insetsY = footerView.bounds.origin.y
        let frame = Layers.getLabelFrame(fromX: insetsX, fromY: insetsY, labelSize: labelSize)
        
        viewsLabel.frame = frame
    }
    
    private func setViewsImages() {
        let rectSide: CGFloat = 20
        let size = CGSize(width: rectSide, height: rectSide)
        
        let positionX = footerView.bounds.width  - viewsLabel.bounds.width - insetsBtwElements - size.width
        let positionY = footerView.bounds.origin.y
        let origin = CGPoint(x: positionX, y: positionY)
        let frame = CGRect(origin: origin, size: size)
        
        viewsImage.frame = frame
    }
    
    private func getCellHeight() -> CGFloat {
        let height = insets * 2 + insetsBtwElements * 3 + authorImage.frame.height + newsLabel.frame.height + newsImage.frame.height + footerView.frame.height
        
        return height
    }
}



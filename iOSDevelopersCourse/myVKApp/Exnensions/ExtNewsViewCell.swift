//
//  ExtNewsViewCell.swift
//  myVKApp
//
//  Created by Natalya on 08/04/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit

extension NewsViewCell {

    func cancelAutoConstraints() {
        authorImage.translatesAutoresizingMaskIntoConstraints = false
        authorNameLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        newsLabel.translatesAutoresizingMaskIntoConstraints = false
        newsImage.translatesAutoresizingMaskIntoConstraints = false
        footerView.translatesAutoresizingMaskIntoConstraints = false
        likesImage.translatesAutoresizingMaskIntoConstraints = false
        likesLabel.translatesAutoresizingMaskIntoConstraints = false
        commentImage.translatesAutoresizingMaskIntoConstraints = false
        commentsLabel.translatesAutoresizingMaskIntoConstraints = false
        repostsImage.translatesAutoresizingMaskIntoConstraints = false
        repostsLabel.translatesAutoresizingMaskIntoConstraints = false
        viewsImage.translatesAutoresizingMaskIntoConstraints = false
        viewsLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setAuthorImageFrame() {
        let rectSide: CGFloat = 45
        let size = CGSize(width: rectSide, height: rectSide)
        
        let position = insets
        let origin = CGPoint(x: position, y: position)
        let frame = CGRect(origin: origin, size: size)

        authorImage.frame = frame
    }
    
    func setAuthorLabelFrame() {
        let labelSize = getHeaderLabelSize(text: authorNameLabel.text!, font: authorNameLabel.font)
        
        let positionX = self.bounds.origin.x + insets + authorImage.bounds.width + insetsBtwElements
        let positionY = insets
        let origin = CGPoint(x: positionX, y: positionY)
        let frame = CGRect(origin: origin, size: labelSize)

        authorNameLabel.frame = frame
        authorNameLabel.numberOfLines = 0
        authorNameLabel.lineBreakMode = .byWordWrapping
        authorNameLabel.sizeToFit()
    }
    
    func setDateLabelFrame() {
        let labelSize = getHeaderLabelSize(text: dateLabel.text!, font: dateLabel.font)
        
        let positionX = insets + authorImage.bounds.width + insetsBtwElements
        let positionY = insets + authorNameLabel.bounds.height + insetsBtwElements
        let origin = CGPoint(x: positionX, y: positionY)
        let frame = CGRect(origin: origin, size: labelSize)

        dateLabel.frame = frame
    }
    
    func setNewsLabelFrame() {
        let labelSize = getLabelSize(text: newsLabel.text!, font: newsLabel.font)
        
        let positionX = insets
        var positionY = insets
        let labelsSize = dateLabel.bounds.maxY + authorNameLabel.bounds.maxY + insetsBtwElements
        
        if authorImage.bounds.maxY >= labelsSize {
            positionY += authorImage.bounds.maxY + insetsBtwElements
        } else {
            positionY += labelsSize + insetsBtwElements
        }
        
        let origin = CGPoint(x: positionX, y: positionY)
        let frame = CGRect(origin: origin, size: labelSize)

        newsLabel.frame = frame
        newsLabel.numberOfLines = 0
        newsLabel.lineBreakMode = .byWordWrapping
        newsLabel.sizeToFit()
    }
    
    func setNewsImageFrame() {
        let width = self.bounds.width - insets * 2
        let height = self.bounds.width + insetsBtwElements
        let imageBlock = CGSize(width: width, height: height)
        
        let positionX = insets
        let positionY = newsLabel.frame.origin.y + newsLabel.bounds.height + insetsBtwElements
        let origin = CGPoint(x: positionX, y: positionY)
        let frame = CGRect(origin: origin, size: imageBlock)

        newsImage.frame = frame
    }
    
    func setFooterViewFrame() {
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
        delegate?.setCellHeight(height, at: index)
    }
    
    private func getHeaderLabelSize(text: String, font: UIFont) -> CGSize {
        let maxWidth = self.bounds.width - authorImage.bounds.width - insetsBtwElements - insets * 2
        let maxHeight = CGFloat.greatestFiniteMagnitude
        let textBlock = CGSize(width: maxWidth, height: maxHeight)
        
        let rect = text.boundingRect(with: textBlock, attributes: [NSAttributedStringKey.font: font], context: nil)
        let width = rect.size.width
        let height = rect.size.height
        
        let labelSize = CGSize(width: ceil(width), height: ceil(height))
        return labelSize
    }
    
    private func getLabelSize(text: String, font: UIFont) -> CGSize {
        let maxWidth = self.bounds.width
        let maxHeight = CGFloat.greatestFiniteMagnitude
        let textBlock = CGSize(width: maxWidth, height: maxHeight)
        
        let rect = text.boundingRect(with: textBlock, attributes: [NSAttributedStringKey.font: font], context: nil)
        let width = rect.size.width
        let height = rect.size.height
        
        let labelSize = CGSize(width: ceil(width), height: ceil(height))
        return labelSize
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
        let labelSize = getLabelSize(text: likesLabel.text!, font: likesLabel.font)
        
        let positionX = likesImage.bounds.width + insetsBtwElements
        let positionY = footerView.bounds.origin.y
        let origin = CGPoint(x: positionX, y: positionY)
        let frame = CGRect(origin: origin, size: labelSize)
        
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
        let labelSize = getLabelSize(text: commentsLabel.text!, font: commentsLabel.font)
        
        let positionX = likesImage.bounds.width + insetsBtwElements + likesLabel.bounds.width + insetsBtwElements + commentImage.bounds.width + insetsBtwElements
        let positionY = footerView.bounds.origin.y
        let origin = CGPoint(x: positionX, y: positionY)
        let frame = CGRect(origin: origin, size: labelSize)
        
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
        let labelSize = getLabelSize(text: repostsLabel.text!, font: repostsLabel.font)
        
        let positionX = likesImage.bounds.width + insetsBtwElements + likesLabel.bounds.width + insetsBtwElements + commentImage.bounds.width + insetsBtwElements + commentsLabel.bounds.width + insetsBtwElements + repostsImage.bounds.width + insetsBtwElements
        let positionY = footerView.bounds.origin.y
        let origin = CGPoint(x: positionX, y: positionY)
        let frame = CGRect(origin: origin, size: labelSize)
        
        repostsLabel.frame = frame
    }
    
    private func setViewsLabel() {
        let labelSize = getLabelSize(text: viewsLabel.text!, font: viewsLabel.font)
        
        let positionX = footerView.bounds.width - labelSize.width
        let positionY = footerView.bounds.origin.y
        let origin = CGPoint(x: positionX, y: positionY)
        let frame = CGRect(origin: origin, size: labelSize)
        
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

//
//  ExtIncomingMsgViewCell.swift
//  myVKApp
//
//  Created by Natalya on 12/04/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit

extension IncomingMsgViewCell {

    func cancelAutoConstraints() {
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    func setMsgLabelFrame() {
        let insetsX = insets * 2 + bubbleTail
        let insetsY = insets
        
        let labelSize = Layers.getLabelSize(text: messageLabel.text!, font: messageLabel.font, in: self, insets: insetsX + msgInset)
        
        let frame = Layers.getLabelFrame(fromX: insetsX, fromY: insetsY, labelSize: labelSize)
        
        messageLabel.frame = frame
        messageLabel.sizeToFit()
    }
    
    func setDateLabelFrame() {
        let insetsX = insets * 2 + bubbleTail
        let insetsY = insets + messageLabel.frame.height + insets
        let labelSize = Layers.getLabelSize(text: dateLabel.text!, font: dateLabel.font, in: self, insets: insetsX + msgInset)
        let fromX = messageLabel.frame.origin.x
        
        let frame = Layers.getLabelFrame(fromX: fromX, fromY: insetsY, labelSize: labelSize)
        
        dateLabel.frame = frame
        messageLabel.sizeToFit()
    }
    
    func setBubbleImage() {
        let posX = CGFloat(0)
        let posY = CGFloat(0)
        let origin = CGPoint(x: posX, y: posY)
        
        let contentWidth = messageLabel.frame.width > dateLabel.frame.width ? messageLabel.frame.width : dateLabel.frame.width
        let width = contentWidth + insets * 2 + bubbleTail
        let height = messageLabel.frame.height  + dateLabel.frame.height + insets * 4
        
        let size = CGSize(width: width, height: height)
        let frame = CGRect(origin: origin, size: size)
        
        bubbleImage.frame = frame
    }
    
    func updateHeight() {
        let height = getCellHeight()
        guard let index = index
            , self.bounds.height != height else { return }
        delegate?.setCellHeight(height, at: index, cell: self)
    }
    
    private func getCellHeight() -> CGFloat {
        let height = insets * 2 + bubbleImage.frame.height
        return height
    }
}

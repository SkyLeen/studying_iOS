//
//  ExtOutcomingMsgViewCell.swift
//  myVKApp
//
//  Created by Natalya on 12/04/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit

extension OutcomingMsgViewCell {
    
    func cancelAutoConstraints() {
        [messageLabel,dateLabel,bubbleImage].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    func setMsgLabelFrame() {
        let maxInsets = insets * 2 + msgInset + bubbleTail
        let labelSize = Layers.getLabelSize(text: messageLabel.text!, font: messageLabel.font, in: self, insets: maxInsets)
        
        let insetsX = self.frame.width - insets - bubbleTail - labelSize.width
        let insetsY = insets * 2
        let frame = Layers.getLabelFrame(fromX: insetsX, fromY: insetsY, labelSize: labelSize)
        
        messageLabel.frame = frame
        messageLabel.sizeToFit()
    }
    
    func setDateLabelFrame() {
        let insetsX = self.frame.origin.x + insets * 2 + msgInset
        let insetsY = insets + messageLabel.frame.height + insets
        let labelSize = Layers.getLabelSize(text: dateLabel.text!, font: dateLabel.font, in: self, insets: insetsX + bubbleTail)
        
        let fromX = self.frame.width - labelSize.width - insets * 2 - bubbleTail
        let frame = Layers.getLabelFrame(fromX: fromX, fromY: insetsY, labelSize: labelSize)
        
        dateLabel.frame = frame
        messageLabel.sizeToFit()
    }
    
    func setBubbleImage() {
         let content = messageLabel.frame.width > dateLabel.frame.width ? messageLabel.frame.origin.x : dateLabel.frame.origin.x
        
        let posX = content - insets * 2
        let posY = CGFloat(0)
        let origin = CGPoint(x: posX, y: posY)
        
        let width = self.frame.width - content + insets * 2
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

//
//  ExtIncomingMsgViewCell.swift
//  myVKApp
//
//  Created by Natalya on 12/04/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit

extension IncomingMsgViewCell {
    
    func getMessage() {
        self.messageLabel.text = nil
        
        if message?.attachments != "" {
            messageLabel.text = (message?.body)! + " [" + (message?.attachments)! + "]"
        } else {
            messageLabel.text = message?.body
        }
        setMsgLabelFrame()
        
        dateLabel.text = Date(timeIntervalSince1970: (message?.date)!).formatted
        setDateLabelFrame()
    }
    
    func cancelAutoConstraints() {
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    func setMsgLabelFrame() {
        let insetsX = insets
        let insetsY = insets
        let formX = insetsX + msgInset
        
        let labelSize = Layers.getLabelSize(text: messageLabel.text!, font: messageLabel.font, in: self, insets: formX)
        let frame = Layers.getLabelFrame(fromX: insetsX, fromY: insetsY, labelSize: labelSize)
        
        messageLabel.frame = frame
        messageLabel.sizeToFit()
    }
    
    func setDateLabelFrame() {
        let labelSize = CGSize(width: messageLabel.frame.width, height: CGFloat(15.0))
        let insetsX = insets
        let insetsY = insets + messageLabel.frame.height
        
        let frame = Layers.getLabelFrame(fromX: insetsX, fromY: insetsY, labelSize: labelSize)
        
        dateLabel.frame = frame
    }
    
    func updateHeight() {
        let height = getCellHeight()
        guard let index = index
            , self.bounds.height != height else { return }
        delegate?.setCellHeight(height, at: index)
    }
    
    private func getCellHeight() -> CGFloat {
        let height = insets * 4 + messageLabel.frame.height  + dateLabel.frame.height
        return height
    }
}

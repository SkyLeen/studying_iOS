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
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setMsgLabelFrame() {
        let insetsX = insets
        let insetsY = insets
        let labelSize = Layers.getLabelSize(text: messageLabel.text!, font: messageLabel.font, in: self, insets: insetsX * 2)
        
        let frame = Layers.getLabelFrame(fromX: insetsX, fromY: insetsY, labelSize: labelSize)
        
        messageLabel.frame = frame
        messageLabel.sizeToFit()
    }
    
    func setDateLabelFrame() {
        let insetsX = insets
        let insetsY = insets + messageLabel.frame.height
        let labelSize = Layers.getLabelSize(text: dateLabel.text!, font: dateLabel.font, in: self, insets: insetsX * 2)
        let fromX = self.frame.width - labelSize.width - insets
        
        let frame = Layers.getLabelFrame(fromX: fromX, fromY: insetsY, labelSize: labelSize)
        
        dateLabel.frame = frame
        messageLabel.sizeToFit()
    }
    
    func updateHeight() {
        let height = getCellHeight()
        guard let index = index
            , self.bounds.height != height else { return }
        delegate?.setCellHeight(height, at: index, cell: self)
    }
    
    private func getCellHeight() -> CGFloat {
        let height = insets * 4 + messageLabel.frame.height  + dateLabel.frame.height
        return height
    }
}

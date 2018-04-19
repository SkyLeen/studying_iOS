//
//  IncomingMsgViewCell.swift
//  myVKApp
//
//  Created by Natalya on 12/04/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit

class IncomingMsgViewCell: UITableViewCell {
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var bubbleImage: UIImageView!
    
    let insets: CGFloat = 5
    let msgInset: CGFloat = 70
    
    weak var delegate: CellHeightDelegate?
    var index: IndexPath?
    
    var message: Message? {
        didSet{
            self.messageLabel.text = nil
            
            if message?.attachmentType != "" {
                messageLabel.text = (message?.body)! + " [" + (message?.attachmentType)! + "]"
            } else {
                messageLabel.text = message?.body
            }
            
            dateLabel.text = Date(timeIntervalSince1970: (message?.date)!).formatted
            
            setMsgLabelFrame()
            setDateLabelFrame()
            setBubbleImage()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cancelAutoConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setMsgLabelFrame()
        setDateLabelFrame()
        setBubbleImage()
    }
}

extension IncomingMsgViewCell {
    
    func updateHeight() {
        let height = getCellHeight()
        guard let index = index
            , self.bounds.height != height else { return }
        delegate?.setCellHeight(height, at: index, cell: self)
    }
    
    private func cancelAutoConstraints() {
        [messageLabel, messageLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setMsgLabelFrame() {
        let insetsX = insets * 3
        let insetsY = insets * 2
        
        let labelSize = Layers.getLabelSize(text: messageLabel.text!, font: messageLabel.font, in: self, insets: insetsX + msgInset)
        
        let frame = Layers.getLabelFrame(fromX: insetsX, fromY: insetsY, labelSize: labelSize)
        
        messageLabel.frame = frame
        messageLabel.sizeToFit()
    }
    
    private func setDateLabelFrame() {
        let insetsX = insets * 2
        let insetsY = insets + messageLabel.frame.height + insets
        let labelSize = Layers.getLabelSize(text: dateLabel.text!, font: dateLabel.font, in: self, insets: insetsX + msgInset)
        let fromX = messageLabel.frame.origin.x
        
        let frame = Layers.getLabelFrame(fromX: fromX, fromY: insetsY, labelSize: labelSize)
        
        dateLabel.frame = frame
        messageLabel.sizeToFit()
    }
    
    private func setBubbleImage() {
        let posX = insets
        let posY = CGFloat(0)
        let origin = CGPoint(x: posX, y: posY)
        
        let contentWidth = messageLabel.frame.width > dateLabel.frame.width ? messageLabel.frame.width : dateLabel.frame.width
        let width = contentWidth + insets * 4
        let height = messageLabel.frame.height  + dateLabel.frame.height + insets * 4
        
        let size = CGSize(width: width, height: height)
        let frame = CGRect(origin: origin, size: size)
        
        bubbleImage.frame = frame
    }
    
    private func getCellHeight() -> CGFloat {
        let height = insets * 2 + bubbleImage.frame.height
        return height
    }
}

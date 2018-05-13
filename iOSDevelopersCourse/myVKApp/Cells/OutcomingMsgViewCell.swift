//
//  OutcomingMessagesViewCell.swift
//  myVKApp
//
//  Created by Natalya on 26/03/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit

class OutcomingMsgViewCell: UITableViewCell {
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var bubbleImage: UIImageView!
    @IBOutlet weak var attachedImage: UIImageView!
    
    let insets: CGFloat = 5
    let msgInset: CGFloat = 70
    
    weak var delegate: CellHeightDelegate?
    var index: IndexPath?
    var attachments: [MessageAttachments]?
    
    var message: Message? {
        didSet{
            messageLabel.text = nil
            attachedImage.image = nil
            
            messageLabel.text = message?.body
            dateLabel.text = Date(timeIntervalSince1970: (message?.date)!).formatted
            setMsgLabelFrame()
            setDateLabelFrame()
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
        setAttachedImageFrame()
        setBubbleImage()
    }
}

extension OutcomingMsgViewCell {
    
    func updateHeight() {
        let height = getCellHeight()
        guard let index = index
            , self.bounds.height != height else { return }
        delegate?.setCellHeight(height, at: index, cell: self)
    }
    
    private func cancelAutoConstraints() {
        [messageLabel,dateLabel,bubbleImage, attachedImage].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setMsgLabelFrame() {
        if let msg = messageLabel.text, msg == "" {
            messageLabel.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
            return
        }
        
        let maxInsets = insets * 3 + msgInset
        let labelSize = Layers.getLabelSize(text: messageLabel.text!, font: messageLabel.font, in: self, insets: maxInsets)
        
        let insetsX = self.frame.width - insets * 2 - labelSize.width
        let insetsY = insets * 2
        let frame = Layers.getLabelFrame(fromX: insetsX, fromY: insetsY, labelSize: labelSize)
        
        messageLabel.frame = frame
        messageLabel.sizeToFit()
    }
    
    private func setDateLabelFrame() {
        let insetsX = self.frame.origin.x + insets * 3 + msgInset
        let labelSize = Layers.getLabelSize(text: dateLabel.text!, font: dateLabel.font, in: self, insets: insetsX)
        let insetsY = self.frame.height - labelSize.height - insets * 3
        
        let fromX = self.frame.width - labelSize.width - insets * 2
        let frame = Layers.getLabelFrame(fromX: fromX, fromY: insetsY, labelSize: labelSize)
        
        dateLabel.frame = frame
        dateLabel.sizeToFit()
    }
    
    func setAttachedImageFrame() {
        if let attachments = attachments, attachments.isEmpty {
            attachedImage.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
            return
        }
        
        let width = self.bounds.width - insets * 3 - msgInset
        let height = width
        let imageBlock = CGSize(width: width, height: height)
        
        let positionX = self.frame.width - insets * 2 - imageBlock.width
        let positionY = messageLabel.frame.origin.y + messageLabel.bounds.height + insets * 2
        let origin = CGPoint(x: positionX, y: positionY)
        let frame = CGRect(origin: origin, size: imageBlock)
        
        attachedImage.frame = frame
    }
    
    func setBubbleImage() {
        var content = messageLabel.frame.width > dateLabel.frame.width ? messageLabel.frame.origin.x : dateLabel.frame.origin.x
        content = attachedImage.frame.width > content ? attachedImage.frame.origin.x : content
        
        let posX = content - insets * 2
        let posY = CGFloat(0)
        let origin = CGPoint(x: posX, y: posY)
        
        let width = self.frame.width - content + insets
        let height = messageLabel.frame.height  + attachedImage.frame.height + dateLabel.frame.height + insets * 4
        let size = CGSize(width: width, height: height)
        
        let frame = CGRect(origin: origin, size: size)
        
        bubbleImage.frame = frame
        bubbleImage.layer.cornerRadius = 16
    }
    
    private func getCellHeight() -> CGFloat {
        let height = insets * 2 + bubbleImage.frame.height
        return height
    }
}


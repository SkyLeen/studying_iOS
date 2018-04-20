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
    let bubbleTail: CGFloat = 35
    
    weak var delegate: CellHeightDelegate?
    var index: IndexPath?
    
    var message: Message? {
        didSet{
            self.messageLabel.text = nil
            
            if message?.attachments != "" {
                messageLabel.text = (message?.body)! + " [" + (message?.attachments)! + "]"
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

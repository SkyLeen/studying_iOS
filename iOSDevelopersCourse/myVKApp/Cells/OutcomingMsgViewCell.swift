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
    
    let insets: CGFloat = 5
    let msgInset: CGFloat = 70
    
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
    }
}

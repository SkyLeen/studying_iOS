//
//  DialogUserMessagesViewCell.swift
//  myVKApp
//
//  Created by Natalya on 26/03/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit

class DialogUserMessagesViewCell: UITableViewCell {

    @IBOutlet weak var friendMessageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var message: Message? {
        didSet{
            getMessage()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        friendMessageLabel.layer.cornerRadius = 10
    }
    
    private func getMessage() {
        self.friendMessageLabel.text = nil
        
        if message?.attachments != "" {
            friendMessageLabel.text = (message?.body)! + " [" + (message?.attachments)! + "]"
        } else {
            friendMessageLabel.text = message?.body
        }
        dateLabel.text = Date(timeIntervalSince1970: (message?.date)!).formatted
    }
}

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
    
    let insets: CGFloat = 5
    let msgInset: CGFloat = 70
    
    weak var delegate: CellHeightDelegate?
    var index: IndexPath?
    
    var message: Message? {
        didSet{
            getMessage()
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

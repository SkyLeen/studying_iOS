//
//  MyGroupsViewCell.swift
//  myVKApp
//
//  Created by Natalya on 24/02/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit

class MyGroupsViewCell: UITableViewCell {
    
    @IBOutlet weak var myGroupNameLabel: UILabel!
    @IBOutlet weak var myGroupImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        Functions().setImageLayersSettings(for: myGroupImageView)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

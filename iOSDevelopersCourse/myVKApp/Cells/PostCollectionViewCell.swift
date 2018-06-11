//
//  PostCollectionViewCell.swift
//  myVKApp
//
//  Created by Natalya on 11/06/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit

protocol PostCollectionViewCellDelegate: class {
    func deleteCollectionViewCell(at index: IndexPath)
}

class PostCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
    
    weak var delegate: PostCollectionViewCellDelegate?
    var index: IndexPath?
    
    @IBAction func deleteItem(_ sender: UIButton) {
        guard let index = index else { return }
        delegate?.deleteCollectionViewCell(at: index)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ImageSettingsHelper.setImageLayersSettings(for: photoImage, mode: .forPhotos)
    }
}

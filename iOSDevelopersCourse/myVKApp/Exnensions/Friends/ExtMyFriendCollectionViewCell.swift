//
//  ExtMyFriendCollectionViewCell.swift
//  myVKApp
//
//  Created by Natalya on 12/04/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit

extension MyFriendCollectionViewCell {
    
    func cancelAutoConstraints() {
        myFriendPhoto.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setImageFrame() {
        let side: CGFloat = self.frame.width
        let size = CGSize(width: ceil(side), height: ceil(side))
        
        let position: CGFloat = 0.0
        let origin = CGPoint(x: position, y: position)
        let frame = CGRect(origin: origin, size: size)
        
        myFriendPhoto.frame = frame
    }
}

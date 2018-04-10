//
//  ExtDialogMessagesTableVC.swift
//  myVKApp
//
//  Created by Natalya on 25/03/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import Foundation
import UIKit

extension DialogMessagesTableVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsMessageArray.count
    }
}

extension DialogMessagesTableVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell!
        
        let message = friendsMessageArray[indexPath.row]
        
        if message.fromId.description != self.userId  {
            let cellFriend = tableView.dequeueReusableCell(withIdentifier: "FriendMessageCell", for: indexPath) as! DialogFriendMessagesViewCell
            cellFriend.message = message
            cellFriend.friendMessageImage.image = friendImage
            
            cell = cellFriend
        }
        else {
            let cellUser = tableView.dequeueReusableCell(withIdentifier: "UserMessageCell", for: indexPath) as! DialogUserMessagesViewCell
            cellUser.message = message
            cellUser.friendMessageImage.image = userImage
            
            cell = cellUser
        }
        
        return cell
    }
}

extension DialogMessagesTableVC {
    
    func sendMessage() {
        
    }
    
    private func getLabelSize(text: String, font: UIFont) -> CGSize {
        let maxWidth = (self.navigationController?.navigationBar.bounds.width)! * 0.7
        let maxHeight = CGFloat.greatestFiniteMagnitude
        let textBlock = CGSize(width: maxWidth, height: maxHeight)
        
        let rect = text.boundingRect(with: textBlock, attributes: [NSAttributedStringKey.font: font], context: nil)
        let width = rect.size.width
        let height = rect.size.height
        
        let labelSize = CGSize(width: ceil(width), height: ceil(height))
        return labelSize
    }
    
    private func setTitleLabel(for label: UILabel) {
        label.text = friendName
        label.textAlignment = NSTextAlignment.left
        label.lineBreakMode = .byTruncatingTail
        label.font = UIFont(name: "HelveticaNeue", size: 16.0)
        label.textColor = .white
        label.frame.size = getLabelSize(text: label.text!, font: label.font)
    }
    
    private func setTitleImage(with label: UILabel) -> UIImageView {
        let insets: CGFloat = 5
        let side = (self.navigationController?.navigationBar.bounds.height)! - insets * 2
        let size = CGSize(width: side, height: side)
        let imageView = UIImageView(image: friendImage?.resizeWithWidth(width: side))
        
        let positionX: CGFloat = (self.navigationController?.navigationBar.frame.midX)! - side - insets
        let positionY = label.frame.midY - side/2
        
        let origin = CGPoint(x: positionX, y: positionY)
        let frame = CGRect(origin: origin, size: size)
        
        imageView.frame = frame
        ImageSettingsHelper.setImageLayersSettings(for: imageView, mode: .forAvatarImages)
        
        return imageView
    }
    
    func setTitle() {
        let navView = UIView()
        let label = UILabel()
        var imageView = UIImageView()
        
        setTitleLabel(for: label)
        label.center = navView.center
        imageView = setTitleImage(with: label)
        
        navView.addSubview(label)
        navView.addSubview(imageView)
        
        navigationItem.titleView = navView
        navView.sizeToFit()
    }
}



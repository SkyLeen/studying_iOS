//
//  ExtMessagesTableVC.swift
//  myVKApp
//
//  Created by Natalya on 25/03/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit

extension MessagesTableVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsMessageArray.count
    }
}

extension MessagesTableVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = friendsMessageArray[indexPath.row]
        
        if message.fromId.description != self.userId  {
            let cellFriend = tableView.dequeueReusableCell(withIdentifier: "IncomingMsgViewCell", for: indexPath) as! IncomingMsgViewCell
            cellFriend.delegate = self
            cellFriend.index = indexPath
            cellFriend.message = message
            cellFriend.updateHeight()

            return cellFriend
        }
        else {
            let cellUser = tableView.dequeueReusableCell(withIdentifier: "OutcomingMsgViewCell", for: indexPath) as! OutcomingMsgViewCell
            cellUser.delegate = self
            cellUser.index = indexPath
            cellUser.message = message
            cellUser.updateHeight()

            return cellUser
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var height: CGFloat = 70
        
        if  let h = heightInCellCash[indexPath] {
            height = h
        } else if let h = heightOutCellCash[indexPath] {
            height = h
        }
        
        return height
    }
}

extension MessagesTableVC: CellHeightDelegate {
    
    func setCellHeight(_ height: CGFloat, at index: IndexPath, cell: UITableViewCell) {
        if let _ = cell as? IncomingMsgViewCell {
            heightInCellCash[index] = height
        } else if let _ = cell as? OutcomingMsgViewCell {
            heightOutCellCash[index] = height
        }
    }
}

extension MessagesTableVC {
    
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
        label.textAlignment = .left
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



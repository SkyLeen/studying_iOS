//
//  ExtDialogViewCell.swift
//  myVKApp
//
//  Created by Natalya on 12/04/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit

extension DialogsViewCell {
    
    func setBackgroungColor() {
        let color = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
        
        if dialog?.readState == 0 && dialog?.out == 0 {
            messageView.backgroundColor = color
            messageTextLabel.backgroundColor = color
            messageDateLabel.backgroundColor = color
            messageFriendLabel.backgroundColor = color
        } else if dialog?.readState == 0 && dialog?.out == 1 {
            messageTextLabel.backgroundColor = color
            messageDateLabel.backgroundColor = color
            messageView.backgroundColor = .white
        } else {
            messageTextLabel.backgroundColor = .white
            messageView.backgroundColor = .white
            messageDateLabel.backgroundColor = .white
            messageFriendLabel.backgroundColor = .white
        }
    }
    
    func getDialogProperties() {
        self.messageFriendLabel.text = nil
        self.messageTextLabel.text = nil
        self.messageDateLabel.text = nil
        
        setImageFrame()
        
        messageDateLabel.text = Date(timeIntervalSince1970: (dialog?.date)!).formatted
        setDateLabelFrame()
        
        if dialog?.attachments != "" {
            messageTextLabel.text = (dialog?.body)! + " [" + (dialog?.attachments)! + "]"
        } else {
            messageTextLabel.text = dialog?.body
        }
        setTextLabelFrame()

        guard let friendId = dialog?.friendId,
            let user = friendId > 0 ? RealmRequests.getFriendData(friend: "\(friendId)") : RealmRequests.getGroupData(group: "\(friendId.magnitude)")
            else { return }
        messageFriendLabel.text = dialog?.title == "" ? user.name : dialog?.title
        setNameLabelFrame()
    }
    
    func cancelAutoConstraints() {
        messageFriendImage.translatesAutoresizingMaskIntoConstraints = false
        messageFriendLabel.translatesAutoresizingMaskIntoConstraints = false
        messageTextLabel.translatesAutoresizingMaskIntoConstraints = false
        messageDateLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setImageFrame() {
        let frame = Layers.getAvatarImageFrame(insets: insets)
        messageFriendImage.frame = frame
    }
    
    func setDateLabelFrame() {
        let labelSize = Layers.getLabelSize(text: messageDateLabel.text!, font: messageDateLabel.font, in: self, insets: CGFloat(0.0))
        let insetsX = self.bounds.width - labelSize.width
        
        let frame = Layers.getLabelFrame(fromX: insetsX, fromY: insets, labelSize: labelSize)
        
        messageFriendLabel.frame = frame
    }
    
    func setNameLabelFrame() {
        let insetsX = insets + messageFriendImage.frame.width + insets + messageDateLabel.frame.width
        let labelSize = Layers.getLabelSize(text: messageFriendLabel.text ?? "", font: messageFriendLabel.font, in: self, insets: insetsX)
        let fromX = insets + messageFriendImage.frame.width + insets
        let frame = Layers.getLabelFrame(fromX: fromX, fromY: insets, labelSize: labelSize)
        
        messageFriendLabel.frame = frame
    }
    
    func setTextLabelFrame() {
        let insetsX = insets + messageFriendImage.frame.width + insets
        let insetsY = messageFriendLabel.frame.maxY + insets
        let labelSize = Layers.getLabelSize(text: messageTextLabel.text!, font: messageTextLabel.font, in: self, insets: insetsX)
        let frame = Layers.getLabelFrame(fromX: insetsX, fromY: insetsY, labelSize: labelSize)
        
        messageTextLabel.frame = frame
    }
}

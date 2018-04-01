//
//  DialogsViewCell.swift
//  myVKApp
//
//  Created by Natalya on 25/03/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit

class DialogsViewCell: UITableViewCell {

    @IBOutlet weak var messageFriendImage: UIImageView!
    @IBOutlet weak var messageFriendLabel: UILabel!
    @IBOutlet weak var messageTextLabel: UILabel!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageDateLabel: UILabel!
    
    private var task: URLSessionTask?
    
    var dialog: Dialog? {
        didSet{
            setBackgroungColor()
            getFriendProperties()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ImageSettingsHelper.setImageLayersSettings(for: messageFriendImage, mode: .forAvatarImages)
    }
    
    private func setBackgroungColor() {
        
        if dialog?.readState == 0 && dialog?.out == 0 {
            messageView.backgroundColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
            messageTextLabel.backgroundColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
        } else if dialog?.readState == 0 && dialog?.out == 1 {
            messageTextLabel.backgroundColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
            messageView.backgroundColor = .white
        } else {
            messageTextLabel.backgroundColor = .white
            messageView.backgroundColor = .white
        }
    }
    
    private func getFriendProperties() {
        self.messageFriendImage.image = UIImage(named: "friends")
        self.messageFriendLabel.text = nil
        self.messageTextLabel.text = nil
        
        task?.cancel()
        task = nil
        
        messageTextLabel.text = dialog?.body
        messageDateLabel.text = Date(timeIntervalSince1970: (dialog?.date)!).formatted
        
        guard let friendId = dialog?.friendId, let user = friendId > 0 ? RealmRequests.getFriendData(friend: "\(friendId)") : RealmRequests.getGroupData(group: "\(friendId.magnitude)") else { return }
        messageFriendLabel.text = dialog?.title == "" ? user.name : dialog?.title
        
        
        guard let path = user.photoUrl, let url = URL(string: path) else { return }
        self.task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else { return }
            let image = UIImage(data: data)
            DispatchQueue.main.async { [weak self] in
                guard let s = self, let responseUrl = response?.url, url == responseUrl else { return }
                s.messageFriendImage.image = image
            }
        }
        self.task?.resume()
    }
}

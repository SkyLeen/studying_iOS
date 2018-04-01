//
//  DialogFriendMessagesViewCell.swift
//  myVKApp
//
//  Created by Natalya on 25/03/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit

class DialogFriendMessagesViewCell: UITableViewCell {


    @IBOutlet weak var friendMessageImage: UIImageView!
    @IBOutlet weak var friendMessageLabel: UILabel!
    
    private var task: URLSessionTask?
    
    var message: Message? {
        didSet{
            getMessageProperties()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ImageSettingsHelper.setImageLayersSettings(for: friendMessageImage, mode: .forAvatarImages)
        friendMessageLabel.layer.cornerRadius = 10
    }
    
    private func getMessageProperties() {
        self.friendMessageImage.image = UIImage(named: "friends")
        self.friendMessageLabel.text = nil
        
        task?.cancel()
        task = nil
        
        
        if message?.attachments != "" {
            friendMessageLabel.text = (message?.body)! + " [" + (message?.attachments)! + "]"
        } else {
            friendMessageLabel.text = message?.body
        }
        //messageDateLabel.text = Date(timeIntervalSince1970: (dialog?.date)!).formatted
        
        guard let friendId = message?.friendId, let user = friendId > 0 ? RealmRequests.getFriendData(friend: "\(friendId)") : RealmRequests.getGroupData(group: "\(friendId.magnitude)") else { return }
        
        guard let path = user.photoUrl, let url = URL(string: path) else { return }
        self.task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else { return }
            let image = UIImage(data: data)
            DispatchQueue.main.async { [weak self] in
                guard let s = self, let responseUrl = response?.url, url == responseUrl else { return }
                s.friendMessageImage.image = image
            }
        }
        self.task?.resume()
    }
}

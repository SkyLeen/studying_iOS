//
//  MyFriendsViewCell.swift
//  myVKApp
//
//  Created by Natalya on 24/02/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit

class MyFriendsViewCell: UITableViewCell {

    @IBOutlet private weak var friendNameLabel: UILabel!
    @IBOutlet private weak var friendImageView: UIImageView!
    
    private var task: URLSessionTask?
    var user: Friend? {
        didSet {
            friendNameLabel.text = user?.name
            getUserImage()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ImageSettingsHelper.setImageLayersSettings(for: friendImageView, mode: .forAvatarImages)
    }
    
    private func getUserImage() {
        friendImageView.image = UIImage(named: "friends")
        task?.cancel()
        task = nil
        guard let path = user?.photoUrl, let url = URL(string: path) else { return }
        DispatchQueue.global().async {
            self.task = URLSession.shared.dataTask(with: url) { (data, response, _) in
                guard let data = data else { return }
                let image = UIImage(data: data)
                DispatchQueue.main.async { [weak self] in
                    guard let s = self, let photoUrl = response?.url, photoUrl == url else { return }
                    s.friendImageView.image = image
                }
            }
            self.task?.resume()
        }
    }
}

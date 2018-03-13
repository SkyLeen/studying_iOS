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
    var user: User? {
        didSet {
            getUserProperties()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ImageSettingsHelper().setImageLayersSettings(for: friendImageView, mode: .forAvatarImages)
    }
    
    private func getUserProperties() {
        friendImageView.image = nil
        task?.cancel()
        task = nil
        friendNameLabel.text = user?.name
        guard let url = user?.photoUrl else { return }
        task = URLSession.shared.dataTask(with: url) { (data, response, _) in
            guard let data = data else { return }
            let image = UIImage(data: data)
            DispatchQueue.main.async { [weak self] in
                guard let s = self else { return }
                guard s.user?.photoUrl == response?.url else { return }
                s.friendImageView.image = image
            }
        }
        task?.resume()
    }
}

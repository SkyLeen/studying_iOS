//
//  AllGroupsViewCell.swift
//  myVKApp
//
//  Created by Natalya on 24/02/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit

class AllGroupsViewCell: UITableViewCell {
    
    @IBOutlet private weak var allGroupNameLabel: UILabel!
    @IBOutlet private weak var allGroupImageView: UIImageView!
    @IBOutlet private weak var allGroupFollowersCountLabel: UILabel!
    
    var task: URLSessionTask?
    var group: Group? {
        didSet {
            allGroupNameLabel.text = group?.nameGroup
            getAllGroupsImage()
            
            guard let followers = group?.followers else { return }
            allGroupFollowersCountLabel.text = "\(followers.withSeparator) followers"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ImageSettingsHelper.setImageLayersSettings(for: allGroupImageView, mode: .forAvatarImages)
    }
    
    private func getAllGroupsImage() {
        allGroupImageView.image = UIImage(named: "groups")
        task?.cancel()
        task = nil
        guard let path = group?.photoGroupUrl, let url = URL(string: path) else { return }
        self.task = URLSession.shared.dataTask(with: url) { (data, response, _) in
            guard let data = data else { return }
            let image = UIImage(data: data)
            DispatchQueue.main.async { [weak self] in
                guard let s = self, let photoUrl = response?.url, photoUrl == url else { return }
                s.allGroupImageView.image = image
            }
        }
        self.task?.resume()
    }
}

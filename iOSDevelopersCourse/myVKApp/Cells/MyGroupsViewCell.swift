//
//  MyGroupsViewCell.swift
//  myVKApp
//
//  Created by Natalya on 24/02/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit

class MyGroupsViewCell: UITableViewCell {
    
    @IBOutlet private weak var myGroupNameLabel: UILabel!
    @IBOutlet private weak var myGroupImageView: UIImageView!
    
    var task: URLSessionTask?
    var group: Group? {
        didSet {
            myGroupNameLabel.text = group?.nameGroup
            getUserGroupImage()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ImageSettingsHelper.setImageLayersSettings(for: myGroupImageView, mode: .forAvatarImages)
    }
    
    private func getUserGroupImage() {
        myGroupImageView.image = nil
        task?.cancel()
        task = nil
        guard let pathUrl = group?.photoGroupUrl, let url = URL(string: pathUrl) else { return }
        task = URLSession.shared.dataTask(with: url) { (data, response, _) in
            guard let data = data else { return }
            let image = UIImage(data: data)
            DispatchQueue.main.async { [weak self] in
                guard let s = self, let photoUrl = response?.url, photoUrl == url else { return }
                s.myGroupImageView.image = image
            }
        }
        task?.resume()
    }
}

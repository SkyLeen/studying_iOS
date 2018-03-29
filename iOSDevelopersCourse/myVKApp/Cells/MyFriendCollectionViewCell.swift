//
//  MyFriendCollectionViewCell.swift
//  myVKApp
//
//  Created by Natalya on 24/02/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit

class MyFriendCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var myFriendPhoto: UIImageView!
    
    var task: URLSessionTask?
    var photo: Photos? {
        didSet {
           getUserPhotos()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ImageSettingsHelper.setImageLayersSettings(for: myFriendPhoto, mode: .forPhotos)
    }
    
    private func getUserPhotos() {
        myFriendPhoto.image = nil
        task?.cancel()
        task = nil
        guard let pathUrl = photo?.photo75Url, let url = URL(string: pathUrl) else { return }
            self.task = URLSession.shared.dataTask(with: url) { (data, response,_) in
                guard let data = data else { return }
                let image = UIImage(data: data)
                DispatchQueue.main.async { [weak self] in
                    guard let s = self, let photoUrl = response?.url, photoUrl == url else { return }
                    s.myFriendPhoto.image = image
                }
            }
            self.task?.resume()
    }
}

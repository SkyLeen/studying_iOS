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
            getAllGroupsProperties()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ImageSettingsHelper.setImageLayersSettings(for: allGroupImageView, mode: .forAvatarImages)
    }
    
    private func getAllGroupsProperties() {
        allGroupImageView.image = nil
        task?.cancel()
        task = nil
        allGroupNameLabel.text = group?.nameGroup
        allGroupFollowersCountLabel.text = "\(group?.followers ?? 0) followers"
        
        guard let url = URL(string: (group?.photoGroupUrl)!) else { return }
        task = URLSession.shared.dataTask(with: url) { (data, response, _) in
            guard let data = data else { return }
            let image = UIImage(data: data)
            DispatchQueue.main.async { [weak self] in
               guard let s = self else { return }
               //guard URL(string: (s.group?.photoGroupUrl) ?? "") == response?.url else { return } //#ToDo: при наличии этой строки падает с ошибкой 'RLMException', reason: 'Object has been deleted or invalidated.' 
               s.allGroupImageView.image = image
            }
        }
        task?.resume()
    }
}

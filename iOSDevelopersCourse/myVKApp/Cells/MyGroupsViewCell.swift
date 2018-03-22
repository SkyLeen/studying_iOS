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
            getCurrentGroupsProperties()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ImageSettingsHelper.setImageLayersSettings(for: myGroupImageView, mode: .forAvatarImages)
    }
    
    private func getCurrentGroupsProperties() {
        myGroupImageView.image = nil
        task?.cancel()
        task = nil
        myGroupNameLabel.text = group?.nameGroup
        guard let url = URL(string: (group?.photoGroupUrl)!) else { return }
        task = URLSession.shared.dataTask(with: url) { (data, response, _) in
            guard let data = data else { return }
            let image = UIImage(data: data)
            DispatchQueue.main.async { [weak self] in
                guard let s = self else { return }
                //guard URL(string: (s.group?.photoGroupUrl) ?? "") == response?.url else { return } //#ToDo: при наличии этой строки падает с ошибкой 'RLMException', reason: 'Object has been deleted or invalidated.' 
                s.myGroupImageView.image = image
            }
        }
        task?.resume()
    }
}

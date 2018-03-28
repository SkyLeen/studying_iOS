//
//  NewsViewCell.swift
//  myVKApp
//
//  Created by Natalya on 24/03/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit

class NewsViewCell: UITableViewCell {

    @IBOutlet weak var authorImage: UIImageView!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var newsLabel: UILabel!
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var repostsLabel: UILabel!
    @IBOutlet weak var viewsLabel: UILabel!
    
    private var task: URLSessionTask?
    private var taskNewsImage: URLSessionTask?
    
    private let imageCache = NSCache<NSString, AnyObject>()
    
    var news: News? {
        didSet {
            authorNameLabel.text = news?.author
            newsLabel.text = news?.text
            likesLabel.text = news?.likesCount
            commentsLabel.text = news?.commentsCount
            repostsLabel.text = news?.repostsCount
            viewsLabel.text = news?.viewsCount

            getAuthorsImages()
            getNewsImages()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ImageSettingsHelper.setImageLayersSettings(for: authorImage, mode: .forAvatarImages)
    }
    
    private func getAuthorsImages() {
        authorImage.image = nil
        task?.cancel()
        task = nil
        guard let path = news?.authorImageUrl, let url = URL(string: path) else { return }
        DispatchQueue.global(qos: .background).async {
            self.task = URLSession.shared.dataTask(with: url){ (data,response,error) in
                guard let data = data, error == nil else { return }
                let image = UIImage(data: data)
                DispatchQueue.main.async  { [weak self] in
                    guard let s = self, let responseUrl = response?.url, responseUrl == url else { return }
                    s.authorImage.image = image
                }
            }
            self.task?.resume()
        }
    }
    
    private func getNewsImages() {
        let canvasSize = newsImage.frame.size.width
       
        newsImage.image = nil
        taskNewsImage?.cancel()
        taskNewsImage = nil
        
        guard let attachments = news?.attachments, !attachments.isEmpty, let path = attachments[0].url, let url = URL(string: path) else { return }
        
        if let cachedImage = self.imageCache.object(forKey: path as NSString) as? UIImage {
            self.newsImage.image = cachedImage
            return
        }
        
        DispatchQueue.global().async {
            self.taskNewsImage = URLSession.shared.dataTask(with: url){ (data,response,error) in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async  { [weak self] in
                    let image = UIImage(data: data)?.resizeWithWidth(width: canvasSize)
                    self?.imageCache.setObject(image!, forKey: path as NSString)
                    guard let s = self, let responseUrl = response?.url, responseUrl == url else { return }
                    s.newsImage.image = image
                }
            }
            self.taskNewsImage?.resume()
        }
    }
}


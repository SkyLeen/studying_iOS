//
//  NewsTableVC.swift
//  myVKApp
//
//  Created by Natalya on 24/03/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import RealmSwift

class NewsTableVC: UITableViewController {
    
    @IBOutlet weak var loadLable: UILabel!
    @IBOutlet weak var acivityIndicator: UIActivityIndicatorView!
    
    let accessToken = KeychainWrapper.standard.string(forKey: "accessToken")
    let userId =  KeychainWrapper.standard.string(forKey: "userId")
    
    var newsArray: Results<News>!
    lazy var newsAttachArray: Results<NewsAttachments> = {
        return RealmLoader.loadData(object: NewsAttachments())
        }()
    
    var token: NotificationToken?
    var imageCache = NSCache<NSString, AnyObject>()
    var taskNewsImage: URLSessionTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 1000
        tableView.rowHeight = UITableViewAutomaticDimension
        
        addRefreshControl()
        
        NewsRequests.getUserNews(userId: self.userId!, accessToken: self.accessToken!)
        loadNewsImages()
        getNotification()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsViewCell
        let newsFeed = newsArray[indexPath.row]
        
        cell.imageCache = imageCache
        cell.news = newsFeed

        return cell
    }
}

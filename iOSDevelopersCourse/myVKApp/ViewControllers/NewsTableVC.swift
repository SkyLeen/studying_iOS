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
    
    let accessToken = KeychainWrapper.standard.string(forKey: "accessToken")
    let userId =  KeychainWrapper.standard.string(forKey: "userId")
    
    lazy var newsArray: Results<News> = {
        return RealmLoader.loadData(object: News()).sorted(byKeyPath: "date", ascending: false)
    }()
    lazy var newsAttachArray: Results<NewsAttachments> = {
        return RealmLoader.loadData(object: NewsAttachments())
    }()
    
    var token: NotificationToken?
    
    var heightCellCash: [IndexPath : CGFloat] = [:]
    
    var opQueue: OperationQueue = {
        let q = OperationQueue()
        q.qualityOfService = .userInteractive
        return q
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "NewsViewCell", bundle: nil), forCellReuseIdentifier: "NewsViewCell")
        addRefreshControl()
        NewsRequests.getUserNews(userId: self.userId!, accessToken: self.accessToken!)
        token = Notifications.getTableViewToken(newsArray, view: self.tableView)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsViewCell", for: indexPath) as! NewsViewCell
        cell.delegate = self
        cell.index = indexPath
        
        let newsFeed = newsArray[indexPath.row]
        let attachments = newsFeed.attachments
             
        cell.news = newsFeed
        
        if let url = newsFeed.authorImageUrl {
            let getImageOp = newsFeed.authorId>0 ? GetCashedImage(url: url, folderName: .UserAvatars, userId: newsFeed.authorId.description) : GetCashedImage(url: url, folderName: .Groups, userId: newsFeed.authorId.magnitude.description)
            let authorReloadedOp = TableCellReloading(indexPath: indexPath, view: tableView, cell: cell, imageView: cell.authorImage)
            authorReloadedOp.addDependency(getImageOp)
            opQueue.addOperation(getImageOp)
            OperationQueue.main.addOperation(authorReloadedOp)
        }
        
        if !attachments.isEmpty, let url = newsFeed.attachments[0].url {
            let getImageOp = GetCashedImage(url: url, folderName: .News)
            let newsReloadedOp = TableCellReloading(indexPath: indexPath, view: tableView, cell: cell, imageView: cell.newsImage)
            newsReloadedOp.addDependency(getImageOp)
            opQueue.addOperation(getImageOp)
            OperationQueue.main.addOperation(newsReloadedOp)
        }
        cell.setNewsImageFrame()
        
        cell.updateHeight()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let height = heightCellCash[indexPath] else { return 120 }
        return height
    }
}

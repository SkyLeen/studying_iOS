//
//  NewsTableVC.swift
//  myVKApp
//
//  Created by Natalya on 24/03/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit
import RealmSwift

class NewsTableVC: UITableViewController {
    
    lazy var newsArray: Results<News> = {
        return RealmLoader.loadData(object: News()).sorted(byKeyPath: "date", ascending: false)
    }()
    
    var token: NotificationToken?
    
    var heightCellCash: [IndexPath : CGFloat] = [:]
    
    var opQueue: OperationQueue = {
        let q = OperationQueue()
        q.qualityOfService = .userInteractive
        return q
    }()
    
    deinit {
        token?.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "NewsViewCell", bundle: nil), forCellReuseIdentifier: "NewsViewCell")
        addRefreshControl()
        NewsRequests.getUserNews()
        token = Notifications.getTableViewTokenSections(newsArray, view: self.tableView)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        let count = !newsArray.isEmpty ? newsArray.count : 100
        return count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = !newsArray.isEmpty ? 1 : 0
        return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsViewCell", for: indexPath) as! NewsViewCell
        cell.delegate = self
        cell.index = indexPath
        
        let newsFeed = newsArray[indexPath.section]
        let attachments = newsFeed.attachments
        
        cell.attachments = Array(attachments)
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

extension NewsTableVC {
    
    private func addRefreshControl() {
        self.refreshControl?.addTarget(self, action: #selector(self.refreshView), for: .valueChanged)
    }
    
    @objc func refreshView(sender: AnyObject) {
        NewsRequests.getUserNews()
        DispatchQueue.main.async { [weak self] in
            guard let s = self else { return }
            s.refreshControl?.endRefreshing()
            s.tableView.reloadData()
        }
    }
}

extension NewsTableVC: CellHeightDelegate {
    
    func setCellHeight(_ height: CGFloat, at index: IndexPath, cell: UITableViewCell) {
        heightCellCash[index] = height
    }
}

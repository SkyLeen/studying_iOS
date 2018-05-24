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
    
    var token: NotificationToken?
    lazy var newsArray: Results<News> = {
        return RealmLoader.loadData(object: News()).sorted(byKeyPath: "date", ascending: false)
    }()
    
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
        
        FriendsRequests.getFriendsList { friends in
            DispatchQueue.main.async {
                CloudFriendsSaver.operateDataCloud(friends: friends)
            }
        }
        DialogsRequests.getUserDialogs(complition: nil)
        GroupsRequests.getUserGroups()
        
        checkRequestsDb()

        token =  Notifications.getTableViewTokenRows(newsArray, view: self.tableView)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
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
        
        cell.attachments = Array(attachments)
        cell.news = newsFeed
        
        if let url = newsFeed.authorImageUrl {
            let getImageOp = newsFeed.authorId>0 ? GetCashedImage(url: url, folderName: .UserAvatars, userId: newsFeed.authorId.description) : GetCashedImage(url: url, folderName: .Groups, userId: newsFeed.authorId.magnitude.description)
            let authorReloadedOp = TableCellReloading(indexPath: indexPath, view: tableView, cell: cell, imageView: cell.authorImage)
            authorReloadedOp.addDependency(getImageOp)
            opQueue.addOperation(getImageOp)
            OperationQueue.main.addOperation(authorReloadedOp)
        }
        
        if !attachments.isEmpty, let url = attachments[0].url {
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
    
    @IBAction func addNewPostPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "showNewPost", sender: nil)
    }
    
}

extension NewsTableVC {
    
    @IBAction func addNewPost(segue: UIStoryboardSegue) {
        guard segue.identifier == "addNewPost" else { return }
        guard let newPostVC = segue.source as? NewPostVC else { return }
        guard let textView = newPostVC.textView else { return }
        var text = textView.text
        
        if let label = newPostVC.locationLabel.text, !label.isEmpty {
            text?.append("""
                
                
                \(label)
                """)
        }
        
        let lat = newPostVC.locationCoordinates?.latitude ?? 0.0
        let long = newPostVC.locationCoordinates?.longitude ?? 0.0
        NewsRequests.postNews(text: text!, lat: lat, long: long)
    }
    
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
    
    private func checkRequestsDb() {
        let arrayFriends = RealmLoader.loadData(object: FriendRequest())
        if arrayFriends.count > 0, let items = tabBarController?.tabBar.items {
            items[2].title = "+ \(arrayFriends.count)"
        } else if let items = tabBarController?.tabBar.items {
            items[2].title = ""
        }
        
        let arrayDialogs = RealmLoader.loadData(object: Dialog()).filter( { $0.readState == 0 } )
        if arrayDialogs.count > 0, let items = tabBarController?.tabBar.items {
            items[1].title = "+ \(arrayDialogs.count)"
        } else if let items = tabBarController?.tabBar.items {
            items[1].title = ""
        }
    }
}

extension NewsTableVC: CellHeightDelegate {
    
    func setCellHeight(_ height: CGFloat, at index: IndexPath, cell: UITableViewCell) {
        heightCellCash[index] = height
    }
}

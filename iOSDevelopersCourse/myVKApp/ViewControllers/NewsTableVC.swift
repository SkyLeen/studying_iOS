//
//  NewsTableVC.swift
//  myVKApp
//
//  Created by Natalya on 24/03/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftKeychainWrapper

class NewsTableVC: UITableViewController {
    
    private let accessToken = KeychainWrapper.standard.string(forKey: "accessToken")
    private let userId =  KeychainWrapper.standard.string(forKey: "userId")
    
    var token: NotificationToken?
    lazy var newsArray: Results<News> = {
        return RealmLoader.loadData(object: News()).sorted(byKeyPath: "date", ascending: false)
    }()
    
    var heightCellCash: [IndexPath : CGFloat] = [:]
    var myTimer: Timer?
    
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
        guard let userId = userId, let accessToken = accessToken else { return }
        NewsRequests.getUserNews(userId: userId, accessToken: accessToken)
        FriendsRequests.getFriendsList { friends in
            DispatchQueue.main.async {
                CloudFriendsSaver.operateDataCloud(friends: friends)
            }
        }
        FriendsRequests.getIncomingFriendsRequest() { _ in }
        DialogsRequests.getUserDialogs(userId: userId, accessToken: accessToken) { _ in
            DispatchQueue.main.async {
                self.checkNewMessages()
            }
        }
        GroupsRequests.getUserGroups()
        
        checkNewRequests()
        token =  Notifications.getTableViewTokenRows(newsArray, view: self.tableView)
        
        self.myTimer = Timer(timeInterval: 20.0, target: self, selector: #selector(self.refreshView), userInfo: nil, repeats: true)
        RunLoop.main.add(self.myTimer!, forMode: RunLoopMode.defaultRunLoopMode)
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
    
    private func addRefreshControl() {
        self.refreshControl?.addTarget(self, action: #selector(self.refreshView), for: .valueChanged)
    }
    
    @objc func refreshView(sender: AnyObject) {
        guard let userId = userId, let accessToken = accessToken else { return }
        NewsRequests.getUserNews(userId: userId, accessToken: accessToken)
        DispatchQueue.main.async { [weak self] in
            guard let s = self else { return }
            s.refreshControl?.endRefreshing()
            s.tableView.reloadData()
        }
    }
    
    private func checkNewRequests() {
        let arrayFriends = RealmLoader.loadData(object: FriendRequest())
        if arrayFriends.count > 0, let items = tabBarController?.tabBar.items {
            items[2].title = "+ \(arrayFriends.count)"
        } else if let items = tabBarController?.tabBar.items {
            items[2].title = ""
        }
    }
    
    private func checkNewMessages() {
        let arrayDialogs = RealmLoader.loadData(object: Dialog()).filter( { $0.readState == 0 && $0.out == 0 } )
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

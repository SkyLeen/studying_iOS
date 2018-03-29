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
    
    var token: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.global(qos: .background).async {
            NewsRequests.getUserNews(userId: self.userId!, accessToken: self.accessToken!)
        }
        
        getNotification()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsViewCell
        
        let newsFeed = newsArray[indexPath.row]
        
        cell.news = newsFeed
        
        return cell
    }
}

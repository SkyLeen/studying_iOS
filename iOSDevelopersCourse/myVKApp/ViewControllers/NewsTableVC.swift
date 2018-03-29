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
    
    var token: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 1000
        tableView.rowHeight = UITableViewAutomaticDimension
        
        addRefreshControl()
        
        DispatchQueue.global(qos: .utility).async {
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

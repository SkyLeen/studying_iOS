//
//  ExtNewsTableVC.swift
//  myVKApp
//
//  Created by Natalya on 27/03/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import RealmSwift
import UIKit

extension NewsTableVC {
    
    func addRefreshControl() {
        self.refreshControl?.addTarget(self, action: #selector(self.refreshView), for: .valueChanged)
    }
    
    @objc func refreshView(sender: AnyObject) {
        NewsRequests.getUserNews(userId: self.userId!, accessToken: self.accessToken!)
        DispatchQueue.main.async { [weak self] in
            guard let s = self else { return }
            s.refreshControl?.endRefreshing()
            s.tableView.reloadData()
        }
    }
}


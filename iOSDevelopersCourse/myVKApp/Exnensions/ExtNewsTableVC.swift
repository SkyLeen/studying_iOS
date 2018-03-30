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
    
    func getNotification() {
        newsArray = RealmLoader.loadData(object: News()).sorted(byKeyPath: "date", ascending: false)
        token = newsArray.observe({ [weak self] changes in
            guard let view = self?.tableView else { return }
            switch changes {
            case .initial:
                view.reloadData()
            case .update(_, let delete, let insert, let update):
                view.beginUpdates()
                view.deleteRows(at: delete.map({ IndexPath(row: $0, section: 0) }), with: .fade)
                view.insertRows(at: insert.map({ IndexPath(row: $0, section: 0) }), with: .fade)
                view.reloadRows(at: update.map({ IndexPath(row: $0, section: 0) }), with: .fade)
                view.endUpdates()
            case .error(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    func loadNewsImages() {
        for item in newsAttachArray {
            guard let path = item.url, let url = URL(string: path) else { return }
            self.taskNewsImage = URLSession.shared.dataTask(with: url){ (data,response,error) in
                guard let data = data, error == nil else { return }
                let image = UIImage(data: data)
                self.imageCache.setObject(image!, forKey: path as NSString)
            }
            self.taskNewsImage?.resume()
        }
    }
    
    func addRefreshControl() {
        self.refreshControl?.addTarget(self, action: #selector(self.refreshView), for: .valueChanged)
    }
    
    @objc func refreshView(sender: AnyObject) {
        NewsRequests.getUserNews(userId: self.userId!, accessToken: self.accessToken!)
        DispatchQueue.main.async {
            self.getNotification()
            self.refreshControl?.endRefreshing()
        }
    }
}


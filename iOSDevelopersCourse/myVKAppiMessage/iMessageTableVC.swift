//
//  iMessageTableVC.swift
//  myVKAppiMessage
//
//  Created by Natalya on 30/05/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit
import Messages
import RealmSwift

class iMessageTableVC: MSMessagesAppViewController {
    
    private var defaults = UserDefaults(suiteName: "group.myVKApp")
    lazy var newsFeed: Results<News>! = {
        return RealmLoader.loadData(object: News()).sorted(byKeyPath: "date", ascending: false)
    }()
    
    let operationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.qualityOfService = .userInteractive
        return queue
    } ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let userId = defaults?.string(forKey: "userId"),
            let accessToken = defaults?.string(forKey: "accessToken")
            else { return }
        NewsRequests.getUserNews(userId: userId, accessToken: accessToken)
        RealmConfigurator.configureRealm()
    }
}

extension iMessageTableVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsFeed.count
    }
}

extension iMessageTableVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! iMessageViewCell
        let layout = MSMessageTemplateLayout()
        layout.imageTitle = cell.friendLabel.text
        layout.imageSubtitle = cell.dateLabel.text
        layout.caption = cell.newsTextLabel.text
        layout.image = cell.newsImage.image
        
        let message = MSMessage()
        message.layout = layout
        self.activeConversation?.insert(message, completionHandler: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as! iMessageViewCell
        let news = newsFeed[indexPath.row]
        let attachments = news.attachments

        cell.news = news
        
        if !attachments.isEmpty, let url = attachments[0].url {
            let getImageOp = GetCashedImage(url: url, folderName: .News)
            getImageOp.completionBlock = {
                OperationQueue.main.addOperation {
                    cell.newsImage.image = getImageOp.outputImage
                }
            }
            operationQueue.addOperation(getImageOp)
        }
        
        return cell
    }
}

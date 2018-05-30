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
        guard let userId = defaults?.string(forKey: "userId"), let accessToken = defaults?.string(forKey: "accessToken") else { return }
        NewsRequests.getUserNews(userId: userId, accessToken: accessToken)
        configureRealm()
    }
}

extension iMessageTableVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsFeed.count
    }
}

extension iMessageTableVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let news = newsFeed[indexPath.row]
        let attachments = news.attachments
        
        
        let sendAction = UITableViewRowAction(style: .normal, title: "Send post") { (rowAction, indexPath) in
            let layout = MSMessageTemplateLayout()
            layout.imageTitle = news.author!
            layout.imageSubtitle = Date(timeIntervalSince1970: (news.date)).formatted
            layout.caption = news.text
            
            if !attachments.isEmpty, let urlPath = attachments[0].url, let url = URL(string: urlPath) {
                let data = try! Data(contentsOf: url)
                layout.image = UIImage(data: data)

// Не получается подгрузить фото из кеша
//                let getImageOp = GetCashedImage(url: urlPath, folderName: .News)
//                getImageOp.completionBlock = {
//                    OperationQueue.main.addOperation {
//                        layout.image = getImageOp.outputImage
//                    }
//                }
//                self.operationQueue.addOperation(getImageOp)
           }
            
            let message = MSMessage()
            message.layout = layout
            self.activeConversation?.insert(message, completionHandler: nil)
        }
        sendAction.backgroundColor = .blue
        
        return [sendAction]
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

extension iMessageTableVC {
    
    private func configureRealm() {
        let configuration = Realm.Configuration(
            fileURL: FileManager
                .default
                .containerURL(forSecurityApplicationGroupIdentifier: "group.myVKApp")?.appendingPathComponent("default.realm"),
            deleteRealmIfMigrationNeeded: true,
            objectTypes: [User.self, Friend.self, FriendRequest.self, Photos.self, Group.self, News.self, NewsAttachments.self, Dialog.self, Message.self, MessageAttachments.self])
        Realm.Configuration.defaultConfiguration = configuration
    }
}

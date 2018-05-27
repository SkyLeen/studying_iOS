//
//  TodayViewController.swift
//  myVKAppWidget
//
//  Created by Natalya on 27/05/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit
import NotificationCenter
import RealmSwift

class TodayViewController: UIViewController, NCWidgetProviding {
    @IBOutlet weak var imageNews: UIImageView!
    @IBOutlet weak var authorNews: UILabel!
    @IBOutlet weak var recNews: UILabel!
    @IBOutlet weak var textNews: UILabel!
    @IBOutlet weak var pages: UIPageControl!
    
    private var defaults = UserDefaults(suiteName: "group.myVKApp")
    lazy var news: Results<News>! = {
        return RealmLoader.loadData(object: News()).sorted(byKeyPath: "date", ascending: false)
    }()
    private var counter = 0
    private let countNews = 20
    
    let operationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.qualityOfService = .userInteractive
        return queue
    } ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let userId = defaults?.string(forKey: "userId"), let accessToken = defaults?.string(forKey: "accessToken") else { return }
        print(userId)
        NewsRequests.getUserNews(userId: userId, accessToken: accessToken)
        configureRealm()
        configurePageControl()
        ImageSettingsHelper.setImageLayersSettings(for: imageNews, mode: .forAvatarImages)
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        completionHandler(NCUpdateResult.newData)
    }
    
    @IBAction func changePage(_ sender: UIPageControl) {
        if counter >= countNews {
            counter = 0
        }
        
        pages.currentPage = counter
        setNews(for: counter)
        counter = counter + 1
    }
}

extension TodayViewController {
    
    private func configurePageControl() {
        pages.numberOfPages = countNews
        pages.currentPage = 0
        pages.tintColor = UIColor.red
        pages.pageIndicatorTintColor = UIColor.black
        pages.currentPageIndicatorTintColor = UIColor.green
        setNews(for: 0)
        counter = counter + 1
    }
    
    private func configureRealm() {
        let configuration = Realm.Configuration(
            fileURL: FileManager
                .default
                .containerURL(forSecurityApplicationGroupIdentifier: "group.myVKApp")?.appendingPathComponent("default.realm"),
            deleteRealmIfMigrationNeeded: true,
            objectTypes: [User.self, Friend.self, FriendRequest.self, Photos.self, Group.self, News.self, NewsAttachments.self, Dialog.self, Message.self, MessageAttachments.self])
        Realm.Configuration.defaultConfiguration = configuration
    }
    
    private func setNews(for page: Int) {
        let newsFeed = news[page]
        authorNews.text = newsFeed.author
        authorNews.sizeToFit()
        textNews.text = newsFeed.text
        recNews.text = "\(newsFeed.likesCount) человек рекомендуют эту новость"
        if let url = newsFeed.authorImageUrl {
            let getImageOp = newsFeed.authorId>0 ? GetCashedImage(url: url, folderName: .UserAvatars, userId: newsFeed.authorId.description) : GetCashedImage(url: url, folderName: .Groups, userId: newsFeed.authorId.magnitude.description)
            getImageOp.completionBlock = {
                OperationQueue.main.addOperation {
                    self.imageNews.image = getImageOp.outputImage
                }
            }
            operationQueue.addOperation(getImageOp)
        }
    }
}

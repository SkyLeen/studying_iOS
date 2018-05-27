//
//  TodayMessagesVC
//  myVKAppMessages
//
//  Created by Natalya on 27/05/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit
import NotificationCenter
import RealmSwift

class TodayMessagesVC: UIViewController, NCWidgetProviding {
    @IBOutlet weak var countUnreaded: UILabel!
    @IBOutlet weak var showAppButton: UIButton!
    
    private var vc = "Dialogs"
    private var defaults = UserDefaults(suiteName: "group.myVKApp")
    lazy var dialogs: Results<Dialog>! = {
        return RealmLoader.loadData(object: Dialog()).filter("readState == 0 && out == 0").sorted(byKeyPath: "date", ascending: false)
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
        showAppButton.layer.cornerRadius = 10
        guard let userId = defaults?.string(forKey: "userId"), let accessToken = defaults?.string(forKey: "accessToken") else { return }
        configureRealm()
        DialogsRequests.getUserDialogs(userId: userId, accessToken: accessToken, complition: nil)
        countUnreaded.text = "\(dialogs.count) unreaded dialogs"
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        completionHandler(NCUpdateResult.newData)
    }
    
    @IBAction func showApp(_ sender: UIButton) {
        if let url = URL(string: "myVKAppWidget://\(vc)") {
            extensionContext?.open(url)
        }
    }
    
}

extension TodayMessagesVC {
    
//    private func configurePageControl() {
//        pages.numberOfPages = countNews
//        pages.currentPage = 0
//        pages.tintColor = UIColor.red
//        pages.pageIndicatorTintColor = UIColor.black
//        pages.currentPageIndicatorTintColor = UIColor.green
//        //setNews(for: 0)
//        counter = counter + 1
//    }
    
    private func configureRealm() {
        let configuration = Realm.Configuration(
            fileURL: FileManager
                .default
                .containerURL(forSecurityApplicationGroupIdentifier: "group.myVKApp")?.appendingPathComponent("default.realm"),
            deleteRealmIfMigrationNeeded: true,
            objectTypes: [User.self, Friend.self, FriendRequest.self, Photos.self, Group.self, News.self, NewsAttachments.self, Dialog.self, Message.self, MessageAttachments.self])
        Realm.Configuration.defaultConfiguration = configuration
    }
    
    private func setDialogs(for index: Int) {
        _ = dialogs[index]
    }
}

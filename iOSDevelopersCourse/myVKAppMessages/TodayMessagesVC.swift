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
    @IBOutlet weak var collectionView: UICollectionView!
    
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
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.layer.cornerRadius = 10
        guard let userId = defaults?.string(forKey: "userId"), let accessToken = defaults?.string(forKey: "accessToken") else { return }
        configureRealm()
        DialogsRequests.getUserDialogs(userId: userId, accessToken: accessToken, complition: nil)
        countUnreaded.text = "\(dialogs.count) unreaded dialogs"
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        completionHandler(NCUpdateResult.newData)
    }
}

extension TodayMessagesVC {
    
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

extension TodayMessagesVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dialogs.count
    }
}

extension TodayMessagesVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "messageWidgetCell", for: indexPath) as! TodayMessageViewCell
        
        let dialog = dialogs[indexPath.row]
        let friendId = dialog.friendId
        
        cell.dialog = dialog
        
        guard dialog.chatId == 0,
            let user = friendId > 0 ? RealmRequests.getFriendData(friend: friendId.description) :
                RealmRequests.getGroupData(group: friendId.magnitude.description),
            let url = user.photoUrl
            else { return cell }

        let getImageOp = friendId > 0 ? GetCashedImage(url: url, folderName: .UserAvatars, userId: friendId.description) : GetCashedImage(url: url, folderName: .Groups, userId: friendId.magnitude.description)
        let cellReloadedOp = CollectionCellReloading(indexPath: indexPath, view: collectionView, cell: cell, imageView: cell.dialogImage)
        cellReloadedOp.addDependency(getImageOp)
        operationQueue.addOperation(getImageOp)
        OperationQueue.main.addOperation(cellReloadedOp)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let url = URL(string: "myVKAppWidget://\(vc)") {
            extensionContext?.open(url)
        }
    }
}

//
//  MyFriendsTableVC.swift
//  myVKApp
//
//  Created by Natalya on 24/02/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import RealmSwift

class MyFriendsTableVC: UITableViewController {
    
    @IBOutlet weak var requests: UIBarButtonItem!
    
    let userId =  KeychainWrapper.standard.string(forKey: "userId")
    
    lazy var myFriendsArray: Results<Friend> = {
        return RealmLoader.loadData(object: Friend()).filter("userId == %@", userId!).sorted(byKeyPath: "lastName")

    }()
    
    lazy var myRequestsArray: Results<FriendRequest> = {
        return RealmLoader.loadData(object: FriendRequest())
    }()
    
    var token: NotificationToken?
    var tokenRequests: NotificationToken?
    
    var opQueue: OperationQueue = {
        let q = OperationQueue()
        q.qualityOfService = .userInteractive
        return q
    }()
    
    deinit {
        token?.invalidate()
        tokenRequests?.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 55

        token = Notifications.getTableViewTokenRows(myFriendsArray, view: self.tableView)
        tokenRequests = getToken(myRequestsArray, view: self.tableView)
        
        if myRequestsArray.count > 0 {
            requestButton("+ \(myRequestsArray.count)")
        }
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            let sectionRowsCount = myFriendsArray.count
            return sectionRowsCount
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! MyFriendsViewCell
            
            let user = myFriendsArray[indexPath.row]
            cell.user = user
            
            guard let url = user.photoUrl else { return cell }
            let getImageOp = GetCashedImage(url: url, folderName: .UserAvatars, userId: user.idFriend)
            let cellReloadedOp = TableCellReloading(indexPath: indexPath, view: tableView, cell: cell, imageView: cell.friendImageView)
            cellReloadedOp.addDependency(getImageOp)
            opQueue.addOperation(getImageOp)
            OperationQueue.main.addOperation(cellReloadedOp)
            
            return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            performSegue(withIdentifier: "showFriendPhotos", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showFriendPhotos" else { return }
        guard let destinationVC = segue.destination as? MyFriendCollectionVC else { return }
        guard let friend = sender as? IndexPath else { return }

        destinationVC.friendName = myFriendsArray[friend.row].name
        destinationVC.friendId = myFriendsArray[friend.row].idFriend
    }
    
}

extension MyFriendsTableVC {
    
    private func getToken<T: Object>(_ array: Results<T>, view: UITableView?) -> NotificationToken {
        let token = array.observe({ [weak view] changes in
            guard let view = view else { return }
            switch changes {
            case .initial:
                view.reloadData()
            case .update:
                //view.beginUpdates()
                //view.reloadData()
                if array.count > 0, let items = self.tabBarController?.tabBar.items {
                    items[2].title = "+ \(array.count)"
                    self.requestButton("+ \(array.count)")
                } else if let items = self.tabBarController?.tabBar.items {
                    items[2].title = ""
                    self.requestButton("")
                }
                //view.endUpdates()
            case .error(let error):
                print(error.localizedDescription)
            }
        })
        
        return token
    }
    
    private func requestButton(_ title: String) {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: #selector(showRequests), for: .touchUpInside)
        button.sizeToFit()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }
    
    @objc private func showRequests() {
        performSegue(withIdentifier: "showRequests", sender: nil)
    }
}

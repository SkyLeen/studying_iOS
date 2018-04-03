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
    
    let accessToken = KeychainWrapper.standard.string(forKey: "accessToken")
    let userId =  KeychainWrapper.standard.string(forKey: "userId")
    
    lazy var myFriendsArray: Results<Friend> = {
        return RealmLoader.loadData(object: Friend()).filter("userId == %@", userId!).sorted(byKeyPath: "lastName")
    }()
    var token: NotificationToken?
    
    var opQueue: OperationQueue = {
        let q = OperationQueue()
        q.qualityOfService = .userInteractive
        return q
    }()
    
    deinit {
        token?.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FriendsRequests.getFriendsList(userId: self.userId!, accessToken: self.accessToken!)
        getNotification()
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
        let cellReloadedOp = MyFriendsCellReloaded(indexPath: indexPath, view: tableView, cell: cell)
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

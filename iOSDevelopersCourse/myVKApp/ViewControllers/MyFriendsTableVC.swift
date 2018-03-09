//
//  MyFriendsTableVC.swift
//  myVKApp
//
//  Created by Natalya on 24/02/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit

struct SectionObjects {
    var sectionName : Character
    var sectionObjects : [User]
}

class MyFriendsTableVC: UITableViewController {
    
    var accessToken = ""
    var userId = ""
    var friendsRequest = MethodRequest()
    var myFriendsArray = [User]()
    
    var myFriendsInitialsArray = [Character]()
    var sectionObjectArray = [SectionObjects]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        friendsRequest.getFrendsList(userId: userId, accessToken: accessToken) { [weak self] friends in
            self?.myFriendsArray = friends
            self?.getSectionObjects()
            self?.tableView.reloadData()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        let sectionsCount = sectionObjectArray.count
        return sectionsCount
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionName = String(myFriendsInitialsArray[section])
        return sectionName
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionRowsCount = sectionObjectArray[section].sectionObjects.count
        return sectionRowsCount
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! MyFriendsViewCell
        cell.friendNameLabel.text = sectionObjectArray[indexPath.section].sectionObjects[indexPath.row].name
        cell.friendImageView.image = sectionObjectArray[indexPath.section].sectionObjects[indexPath.row].photo
        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showFriendPhotos", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showFriendPhotos" else { return }
        guard let destinationVC = segue.destination as? MyFriendCollectionVC else { return }
        guard let friend = sender as? IndexPath else { return }
        
        destinationVC.friendName = sectionObjectArray[friend.section].sectionObjects[friend.row].name
        destinationVC.accessToken = accessToken
        destinationVC.userId = userId
        destinationVC.friendId = sectionObjectArray[friend.section].sectionObjects[friend.row].idUser
    }
    
    private func getInitialsArray() {
        for (_, friend) in myFriendsArray.enumerated() {
            if !myFriendsInitialsArray.contains(friend.name.first!) {
                myFriendsInitialsArray.append(friend.name.first!)
            }
        }
        myFriendsInitialsArray.sort(by: {$0 < $1})
    }
    
    private func getSectionObjects() {
        getInitialsArray()
       
        for initial in myFriendsInitialsArray {
            let names: [User] = myFriendsArray.filter({ $0.name.first! == initial })
            sectionObjectArray.append(SectionObjects(sectionName: initial, sectionObjects: names.sorted(by: { $0.name < $1.name })))
        }
    }
}

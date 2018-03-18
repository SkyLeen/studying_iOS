//
//  MyFriendsTableVC.swift
//  myVKApp
//
//  Created by Natalya on 24/02/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit
import  SwiftKeychainWrapper
import RealmSwift

struct SectionObjects {
    var section: Character
    var users: [Friend]
}

class MyFriendsTableVC: UITableViewController {
    
    let accessToken = KeychainWrapper.standard.string(forKey: "accessToken")
    let userId =  KeychainWrapper.standard.string(forKey: "userId")
    
    var myFriendsArray = [Friend]()
    var myFriendsInitialsArray = [Character]()
    var sectionObjectArray = [SectionObjects]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
         FriendsRequests().getFriendsList(userId: userId!, accessToken: accessToken!) { [weak self] in
            self?.loadFriendsData()
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
        let sectionRowsCount = sectionObjectArray[section].users.count
        return sectionRowsCount
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! MyFriendsViewCell
        cell.user = sectionObjectArray[indexPath.section].users[indexPath.row]
        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showFriendPhotos", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showFriendPhotos" else { return }
        guard let destinationVC = segue.destination as? MyFriendCollectionVC else { return }
        guard let friend = sender as? IndexPath else { return }

        destinationVC.friendName = sectionObjectArray[friend.section].users[friend.row].name
        destinationVC.friendId = sectionObjectArray[friend.section].users[friend.row].idFriend
    }
    
    private func loadFriendsData() {
        do {
            let realm = try Realm()
            let friends = realm.objects(Friend.self)
            myFriendsArray = Array(friends)
        } catch {
            print(error.localizedDescription)
        }
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
            let names: [Friend] = myFriendsArray.filter({ $0.name.first! == initial })
            sectionObjectArray.append(SectionObjects(section: initial, users: names.sorted(by: { $0.name < $1.name })))
        }
    }
}

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
    var sectionObjects : [(name: String, mainPhoto: UIImage?, photos: [UIImage?])]
}

class MyFriendsTableVC: UITableViewController {
    
    var myFriendsArray = [
        (name: "Катина Катя", mainPhoto: UIImage(named: "friend1.jpg"), photos:[]),
        (name: "Машина Маша",mainPhoto: UIImage(named: "friend2.jpg"), photos: [
                                                                        UIImage(named: "friend2.jpg"),
                                                                        UIImage(named: "friend3.jpg"),
                                                                        UIImage(named: "friend4.jpg"),
                                                                        UIImage(named: "kudago.jpg"),
                                                                        UIImage(named: "namalevich.jpg")
                                                                       ]),
        (name: "Иванов Иван", mainPhoto: UIImage(named: "friend3.jpg"),photos: [
                                                                        UIImage(named: "friend3.jpg"),
                                                                        UIImage(named: "friend4.jpg"),
                                                                        UIImage(named: "friend5.jpg")
                                                                       ]),
        (name:"Марусин Илья",mainPhoto: UIImage(named: "friend4.jpg"), photos: [
                                                                        UIImage(named: "friend4.jpg"),
                                                                        UIImage(named: "friend5.jpg"),
                                                                        UIImage(named: "friend1.jpg"),
                                                                        UIImage(named: "geekbrains.jpg")
                                                                       ]),
        (name: "Васин Вася",mainPhoto: UIImage(named: "friend5.jpg"), photos: [
                                                                        UIImage(named: "friend1.jpg"),
                                                                        UIImage(named: "friend2.jpg"),
                                                                        UIImage(named: "friend5.jpg")
                                                                       ])
    ]
    var myFriendsInitialsArray = [Character]()
    var sectionObjectArray = [SectionObjects]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getSectionObjects()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        let sectionsCount = sectionObjectArray.count
        return sectionsCount
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionName = String(myFriendsInitialsArray[section])
        return sectionName.uppercased()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionRowsCount = sectionObjectArray[section].sectionObjects.count
        return sectionRowsCount
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! MyFriendsViewCell
        cell.friendNameLabel.text = sectionObjectArray[indexPath.section].sectionObjects[indexPath.row].name
        cell.friendImageView.image = sectionObjectArray[indexPath.section].sectionObjects[indexPath.row].mainPhoto
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
        destinationVC.friendPhotos = sectionObjectArray[friend.section].sectionObjects[friend.row].photos as! [UIImage]
    }
    
    private func getInitialsArray() {
        for (_, name) in myFriendsArray.enumerated() {
            if !myFriendsInitialsArray.contains(name.name.first!) {
                myFriendsInitialsArray.append(name.name.first!)
            }
        }
        myFriendsInitialsArray.sort(by: {$0 < $1})
    }
    
    private func getSectionObjects() {
        getInitialsArray()

        for initial in myFriendsInitialsArray {
            let names: [(name: String, mainPhoto: UIImage?, photos: [UIImage?])] = myFriendsArray.filter({ $0.name.first! == initial })
            sectionObjectArray.append(SectionObjects(sectionName: initial, sectionObjects: names.sorted(by: { $0.name < $1.name })))
        }
    }
}

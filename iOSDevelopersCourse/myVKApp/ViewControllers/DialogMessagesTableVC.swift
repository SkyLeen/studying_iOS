//
//  MessagesFriendTableVC.swift
//  myVKApp
//
//  Created by Natalya on 25/03/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import RealmSwift

class DialogMessagesTableVC: UIViewController {

    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var friendId = 0
    
    var friendsMessageArray = [
        (friendId: 1, friend: "friendName1", message: "Message1Message1Message1"),
        (friendId: 2, friend: "friendName2", message:"Message2  Message2Message2Message2 Message2 Message2Message2Message2Message2"),
        (friendId: 3, friend: "friendName3", message:"Message3Message3Message3Message3Message3Message3 Message3Message3Message3 Message3"),
        (friendId: 4, friend: "friendName4", message:"Message4 Message4 Message4 Message4 Message4 Message4 Message4 Message4 Message4 Message4 Message4 Message4 Message4 Message4 Message4 Message4 Message4 Message4 Message4 Message4 Message4 Message4Message4Message4"),
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getTitle()
        textView.layer.cornerRadius = 10
        
        let hideKbGesture = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        self.scrollView?.addGestureRecognizer(hideKbGesture)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setMessageTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden), name: .UIKeyboardWillHide, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func hideKeyboard() {
        self.scrollView?.endEditing(true)
    }

    @objc func keyboardWasShown(notification: Notification) {
        let kbInfo = notification.userInfo! as NSDictionary
        let kbSize = (kbInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        
        self.view.frame.origin.y -= kbSize.height
    }

    @objc func keyboardWillBeHidden(notification: Notification) {
        self.view.frame.origin.y = 0
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        hideKeyboard()
        sendMessage()
    }
    
    private func getTitle() {
        guard let user: (name: String, photoUrl: String?) = RealmRequests.getFriendData(friend: "\(friendId)") else { return }
        navigationItem.title = user.name
    }
}

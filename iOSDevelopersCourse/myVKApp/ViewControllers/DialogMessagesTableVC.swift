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
    
    let accessToken = KeychainWrapper.standard.string(forKey: "accessToken")
    let userId =  KeychainWrapper.standard.string(forKey: "userId")
    
    var friendId = 0
    
    lazy var friendsMessageArray: Results<Message> = {
        return RealmLoader.loadData(object: Message()).filter("friendId == %@", friendId).sorted(byKeyPath: "date", ascending: true)
    }()
    
    var messageToken: NotificationToken?
    
    var opQueue: OperationQueue = {
        let q = OperationQueue()
        q.qualityOfService = .userInteractive
        return q
    }()
    
    deinit {
        messageToken?.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getTitle()
        textView.layer.cornerRadius = 10
        DialogsRequests.getMessages(accessToken: accessToken!, friendId: friendId.description)
        messageToken = Notifications.getTableViewToken(friendsMessageArray, view: self.messageTableView)
        
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
}

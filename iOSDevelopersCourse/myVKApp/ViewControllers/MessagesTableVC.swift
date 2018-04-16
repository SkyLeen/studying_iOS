//
//  MessagesFriendTableVC.swift
//  myVKApp
//
//  Created by Natalya on 25/03/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftKeychainWrapper

class MessagesTableVC: UIViewController {

    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    private let userId =  KeychainWrapper.standard.string(forKey: "userId")
    
    var friendId = 0
    var friendName = ""
    var friendImage: UIImage?
    var dialogId = ""
    var chatId = 0
    
    var heightInCellCash: [IndexPath : CGFloat] = [:]
    var heightOutCellCash: [IndexPath : CGFloat] = [:]
    
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
        setTitle()
        setTextView()
        DialogsRequests.getMessages(friendId: friendId.description)
        messageToken = Notifications.getTableViewTokenRows(friendsMessageArray, view: self.messageTableView)
        
        let hideKbGesture = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        self.scrollView?.addGestureRecognizer(hideKbGesture)
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
        let kbInfo = notification.userInfo! as NSDictionary
        let kbSize = (kbInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        self.view.frame.origin.y += kbSize.height
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        hideKeyboard()
        sendMessage()
    }
    
    private func sendMessage() {
        textView.resignFirstResponder()
        
        guard let text = textView.text, !text.isEmpty else { return }
        let destination = chatId > 0 ? 2_000_000_000 + chatId : friendId
        DialogsRequests.sendMessage(to: destination, chatId: chatId, text: text)
        
        let message = Message()
        message.body = text
        message.date = Date().timeIntervalSince1970
        message.friendId = destination
        message.fromId = Int(userId!)!
        message.readState = 0
        message.out = 1
        message.id = ""
        print(message)
        self.textView.text.removeAll()
    }
}

extension MessagesTableVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsMessageArray.count
    }
}

extension MessagesTableVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = friendsMessageArray[indexPath.row]
        
        if message.out == 0 {
            let cellFriend = tableView.dequeueReusableCell(withIdentifier: "IncomingMsgViewCell", for: indexPath) as! IncomingMsgViewCell
            cellFriend.delegate = self
            cellFriend.index = indexPath
            cellFriend.message = message
            cellFriend.updateHeight()
            
            return cellFriend
        }
        else {
            let cellUser = tableView.dequeueReusableCell(withIdentifier: "OutcomingMsgViewCell", for: indexPath) as! OutcomingMsgViewCell
            cellUser.delegate = self
            cellUser.index = indexPath
            cellUser.message = message
            cellUser.updateHeight()
            
            return cellUser
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat = 70
        if  let h = heightInCellCash[indexPath] {
            height = h
        } else if let h = heightOutCellCash[indexPath] {
            height = h
        }
        return height
    }
}

extension MessagesTableVC: CellHeightDelegate {
    
    func setCellHeight(_ height: CGFloat, at index: IndexPath, cell: UITableViewCell) {
        if let _ = cell as? IncomingMsgViewCell {
            heightInCellCash[index] = height
        } else if let _ = cell as? OutcomingMsgViewCell {
            heightOutCellCash[index] = height
        }
    }
}

extension MessagesTableVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendMessage()
        
        return true
    }
}

extension MessagesTableVC {
    
    private func setTitle() {
        let navView = UIView()
        let label = UILabel()
        var imageView = UIImageView()
        
        setTitleLabel(for: label)
        label.center = navView.center
        imageView = setTitleImage(with: label)
        
        navView.addSubview(label)
        navView.addSubview(imageView)
        
        navigationItem.titleView = navView
        navView.sizeToFit()
    }
    
    private func setTextView() {
        textView.layer.cornerRadius = 10
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.darkGray.cgColor
    }
    
    private func getLabelSize(text: String, font: UIFont) -> CGSize {
        let maxWidth = (self.navigationController?.navigationBar.bounds.width)! * 0.7
        let maxHeight = CGFloat.greatestFiniteMagnitude
        let textBlock = CGSize(width: maxWidth, height: maxHeight)
        
        let rect = text.boundingRect(with: textBlock, attributes: [NSAttributedStringKey.font: font], context: nil)
        let width = rect.size.width
        let height = rect.size.height
        
        let labelSize = CGSize(width: ceil(width), height: ceil(height))
        return labelSize
    }
    
    private func setTitleLabel(for label: UILabel) {
        label.text = friendName
        label.textAlignment = .left
        label.lineBreakMode = .byTruncatingTail
        label.font = UIFont(name: "HelveticaNeue", size: 16.0)
        label.textColor = .white
        label.frame.size = getLabelSize(text: label.text!, font: label.font)
    }
    
    private func setTitleImage(with label: UILabel) -> UIImageView {
        let insets: CGFloat = 5
        let side = (self.navigationController?.navigationBar.bounds.height)! - insets * 2
        let size = CGSize(width: side, height: side)
        let imageView = UIImageView(image: friendImage?.resizeWithWidth(width: side))
        
        let positionX: CGFloat = (self.navigationController?.navigationBar.frame.midX)! - side - insets
        let positionY = label.frame.midY - side/2
        
        let origin = CGPoint(x: positionX, y: positionY)
        let frame = CGRect(origin: origin, size: size)
        
        imageView.frame = frame
        ImageSettingsHelper.setImageLayersSettings(for: imageView, mode: .forAvatarImages)
        
        return imageView
    }
}

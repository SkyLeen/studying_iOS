//
//  NewPostTableVC.swift
//  myVKApp
//
//  Created by Natalya on 13/05/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit

class NewPostVC: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var barView: UIView!
    @IBOutlet weak var friendButton: UIButton!
    @IBOutlet weak var photosButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.becomeFirstResponder()
        textView.delegate = self
        
        cancelAutoConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown), name: .UIKeyboardWillShow, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWasShown(notification: Notification) {
        let kbInfo = notification.userInfo! as NSDictionary
        let kbSize = (kbInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        
        setBarViewFrame(kbSize: kbSize.height)
        setTextViewsFrame()
        setBarItemsFrames()
    }

    @IBAction func sendPost(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func cancelPost(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}

extension NewPostVC: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        if !textView.text.isEmpty {
            navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
}

extension NewPostVC {
    
    private func cancelAutoConstraints() {
        [textView, barView,
         friendButton, photosButton, locationButton
            ].forEach {
                $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setBarViewFrame(kbSize: CGFloat) {
        let maxWidth = self.view.bounds.width
        let maxHeight: CGFloat = 35
        let viewSize = CGSize(width: maxWidth, height: maxHeight)
        
        let positionX = self.view.frame.origin.x
        let positionY = self.view.bounds.height - kbSize - viewSize.height
        let origin = CGPoint(x: positionX, y: positionY)
        let frame = CGRect(origin: origin, size: viewSize)
        
        barView.frame = frame
    }
    
    private func setTextViewsFrame() {
        let maxWidth = self.view.bounds.width
        let maxHeight = barView.frame.minY
        let viewSize = CGSize(width: maxWidth, height: maxHeight)
        
        let origin = CGPoint(x: 0, y: 0)
        let frame = CGRect(origin: origin, size: viewSize)
        
        textView.frame = frame
    }
    
    private func setBarItemsFrames() {
        let inset: CGFloat = 60
        let side: CGFloat = 20
        let size = CGSize(width: side, height: side)
        
        let positionY = barView.bounds.midY - side/2
        
        let posFriendX = barView.frame.midX - side/2
        let originFriend = CGPoint(x: posFriendX, y: positionY)
        let frameFriend = CGRect(origin: originFriend, size: size)

        friendButton.frame = frameFriend
        
        let posLocX = friendButton.frame.origin.x - inset - side
        let originLoc = CGPoint(x: posLocX, y: positionY)
        let frameLoc = CGRect(origin: originLoc, size: size)
        
        locationButton.frame = frameLoc
        
        let posPhotosX = friendButton.frame.origin.x + side + inset
        let originPhotos = CGPoint(x: posPhotosX, y: positionY)
        let framePhotos = CGRect(origin: originPhotos, size: size)
        
        photosButton.frame = framePhotos
    }
}

//
//  NewPostTableVC.swift
//  myVKApp
//
//  Created by Natalya on 13/05/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit
import CoreLocation

class NewPostVC: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var barView: UIView!
    @IBOutlet weak var friendButton: UIButton!
    @IBOutlet weak var photosButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var locationCoordinates: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        textView.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    @objc func keyboardWasShown(notification: Notification) {
        let info = notification.userInfo! as NSDictionary
        let kbSize = (info.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        bottomConstraint.constant = kbSize.height
    }
    
    @IBAction func addLocation(segue: UIStoryboardSegue) {
        guard segue.identifier == "addLocation" else { return }
        guard let mapVC = segue.source as? MapVC else { return }
        self.locationLabel.text = mapVC.placeName
        self.locationCoordinates = mapVC.locationCoordinates
    }
    
    @IBAction func cancelPost(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}

extension NewPostVC: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        checkTextViewActivity(textView)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        checkTextViewActivity(textView)
    }
}

extension NewPostVC {
    
    private func checkTextViewActivity(_ textView: UITextView) {
        if !textView.text.isEmpty {
            navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
}

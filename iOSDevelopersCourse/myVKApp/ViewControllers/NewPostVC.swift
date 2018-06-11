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
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var locationCoordinates: CLLocationCoordinate2D?
    var attachedImages: [Photos]?
    
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
    
    @IBAction func addNewPost(_ sender: UIBarButtonItem) {
        var text = textView.text
        
        if let label = locationLabel.text, !label.isEmpty {
            text?.append("""
                
                
                \(label)
                """)
        }
        
        let lat = locationCoordinates?.latitude ?? 0.0
        let long = locationCoordinates?.longitude ?? 0.0
        NewsRequests.postNews(text: text!, attachment: attachedImages, lat: lat, long: long)
        
        dismiss(animated: true)
    }
    
    @IBAction func cancelPost(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func openPhotoLibrary(_ sender: UIButton) {
        openLibrary()
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

extension NewPostVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        let imageUrl = info[UIImagePickerControllerImageURL] as? URL
        
        if let image = originalImage, let url = imageUrl {
            attachImage(image)
            uploadImageToServer(url)
        }
        
        dismiss(animated: true)
    }
}

extension NewPostVC {
    
    private func uploadImageToServer(_ imageUrl: URL) {
        //PhotosRequests.uploadPhotosToServer(imageUrl)
    }
    
    private func attachImage(_ image: UIImage) {
        var attributedString: NSMutableAttributedString!
        attributedString = NSMutableAttributedString(attributedString: textView.attributedText)
        
        let attachment = NSTextAttachment()
        attachment.image = image
        
        if let imageAttach = attachment.image, let image =  imageAttach.cgImage {
            let scale = imageAttach.size.width / ((textView.frame.width - 10) / 5)
            
            let attachImage = UIImage(cgImage: image, scale: scale, orientation: .up)
            attachment.image = attachImage
            
        }
        
        let attributedStringWithImage = NSAttributedString(attachment: attachment)
        attributedString.append(attributedStringWithImage)
        attributedString.append(NSAttributedString(string: "  "))
        
        textView.attributedText = attributedString
    }
    
    private func openLibrary() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else { return }
        
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        picker.allowsEditing = false
        picker.delegate = self
        present(picker, animated: true)
    }
    
    private func checkTextViewActivity(_ textView: UITextView) {
        if !textView.text.isEmpty {
            navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
}

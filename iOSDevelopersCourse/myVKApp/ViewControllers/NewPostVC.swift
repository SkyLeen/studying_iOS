//
//  NewPostTableVC.swift
//  myVKApp
//
//  Created by Natalya on 13/05/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit
import CoreLocation
import Photos

class NewPostVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var locationCoordinates: CLLocationCoordinate2D?
    var attachedImagesForPost = [Photos]()
    var attachedImages = [UIImage]() {
        didSet {
            DispatchQueue.main.async {
                if (!self.textView.text.isEmpty) || (self.attachedImages.count > 0 && self.attachedImages.count <= 5)  {
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                } else {
                    self.navigationItem.rightBarButtonItem?.isEnabled = false
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.delegate = self
        textView.becomeFirstResponder()
        
        collectionView.delegate = self
        collectionView.dataSource = self
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
        let text = textView.text
        
        let lat = locationCoordinates?.latitude ?? 0.0
        let long = locationCoordinates?.longitude ?? 0.0
        NewsRequests.postNews(text: text!, attachment: attachedImagesForPost, lat: lat, long: long)

        dismiss(animated: true)
    }
    
    @IBAction func cancelPost(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func openPhotoLibrary(_ sender: UIButton) {
        openLibrary()
    }
    
}

extension NewPostVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return attachedImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postPhoto", for: indexPath) as! PostCollectionViewCell
        let photo = attachedImages[indexPath.row]
        
        cell.delegate = self
        cell.photoImage.image = photo
        cell.index = indexPath
        
        return cell
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
        textView.becomeFirstResponder()
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        let imageUrl = info[UIImagePickerControllerImageURL] as? URL
        
        if let image = originalImage, let url = imageUrl {
            PhotosRequests.uploadPhotosToServer(url) { [weak self] photosPost in
                guard let s = self else { return }
                if let photos = photosPost {
                    for photo in photos {
                        s.attachedImagesForPost.append(photo)
                        s.attachedImages.append(image)
                    }
                }
                
                if s.attachedImages.count > 5 {
                    s.navigationItem.rightBarButtonItem?.isEnabled = false
                }
                
                DispatchQueue.main.async {
                    s.collectionView.reloadData()
                    picker.dismiss(animated: true)
                    s.textView.becomeFirstResponder()
                }
            }
        }
    }
}

extension NewPostVC: PostCollectionViewCellDelegate {
    
    func deleteCollectionViewCell(at index: IndexPath) {
        attachedImagesForPost.remove(at: index.row)
        attachedImages.remove(at: index.row)
        collectionView.deleteItems(at: [index])
    }
}

extension NewPostVC {
    
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
        if !textView.text.isEmpty || (attachedImages.count > 0 && attachedImages.count <= 5) {
            navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
}

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
    
    var locationCoordinates: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        textView.becomeFirstResponder()
    }
    
    @IBAction func addLocation(segue: UIStoryboardSegue) {
        guard segue.identifier == "addLocation" else { return }
        guard let mapVC = segue.source as? MapVC else { return }
        self.locationLabel.text = mapVC.placeName
        self.locationCoordinates = mapVC.locationCoordinates
    }
    
//    @IBAction func addNewPost(_ sender: UIBarButtonItem) {
//        guard let canSend = navigationItem.rightBarButtonItem?.isEnabled, canSend else { return }
//        guard !textView.text.isEmpty else { return }
//        var text = textView.text
//            
//        if let label = locationLabel.text, !label.isEmpty {
//            text?.append("""
//            
//            
//            \(label)
//            """)
//        }
//        
//        let lat = locationCoordinates?.latitude ?? 0.0
//        let long = locationCoordinates?.longitude ?? 0.0
//        NewsRequests.postNews(text: text!, lat: lat, long: long)
//        dismiss(animated: true, completion: nil)
//    }
    
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

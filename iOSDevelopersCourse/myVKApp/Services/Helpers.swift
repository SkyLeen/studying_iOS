//
//  Helpers.swift
//  myVKApp
//
//  Created by Natalya on 25/02/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit
import RealmSwift

struct AlertHelper {
    func showAlert(withTitle title: String, message: String) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionButton = UIAlertAction(title: "OK", style: .cancel)
        
        alertController.addAction(actionButton)
        
        return alertController
    }
}

struct ImageSettingsHelper {
    enum ImageSettingsModes {
        case forAvatarImages
        case forPhotos
    }
    
    func setImageLayersSettings(for view: UIImageView, mode: ImageSettingsModes) {
        switch mode {
        case .forAvatarImages:
            view.layer.cornerRadius = view.bounds.height/2
        case .forPhotos:
            view.layer.cornerRadius = 16
        }
        
        view.layer.masksToBounds = true
    }
}

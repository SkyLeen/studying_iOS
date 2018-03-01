//
//  Functions.swift
//  myVKApp
//
//  Created by Natalya on 25/02/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit

class Functions {
    
    func showAlert(withTitle title: String, message: String) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionButton = UIAlertAction(title: "OK", style: .cancel)
        
        alertController.addAction(actionButton)
        
        return alertController
    }
    
    func setImageLayersSettings(for view: UIImageView) {
        view.layer.cornerRadius = view.bounds.height/2
        view.layer.masksToBounds = true
    }
}

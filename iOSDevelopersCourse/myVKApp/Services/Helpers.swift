//
//  Helpers.swift
//  myVKApp
//
//  Created by Natalya on 25/02/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit
import RealmSwift

class AlertHelper {
    
    static func showAlert(withTitle title: String, message: String) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionButton = UIAlertAction(title: "OK", style: .cancel)
        
        alertController.addAction(actionButton)
        
        return alertController
    }
}

class ImageSettingsHelper {
    
    enum ImageSettingsModes {
        case forAvatarImages
        case forPhotos
    }
    
    static func setImageLayersSettings(for view: UIImageView, mode: ImageSettingsModes) {
        switch mode {
        case .forAvatarImages:
            view.layer.cornerRadius = view.bounds.height/2
        case .forPhotos:
            view.layer.cornerRadius = 16
        }
        view.layer.masksToBounds = true
    }
}

class Notifications {
    
   static func getTableViewTokenRows<T: Object>(_ array: Results<T>, view: UITableView?) -> NotificationToken {
        let token = array.observe({ [weak view] changes in
            guard let view = view else { return }
            switch changes {
            case .initial:
                view.reloadData()
            case .update(_, let delete, let insert, let update):
                view.beginUpdates()
                view.deleteRows(at: delete.map({ IndexPath(row: $0, section: 0) }), with: .none)
                view.insertRows(at: insert.map({ IndexPath(row: $0, section: 0) }), with: .none)
                view.reloadRows(at: update.map({ IndexPath(row: $0, section: 0) }), with: .none)
                view.endUpdates()
            case .error(let error):
                print(error.localizedDescription)
            }
        })
        
        return token
    }
    
    static func getTableViewTokenSections<T: Object>(_ array: Results<T>, view: UITableView?) -> NotificationToken {
        let token = array.observe({ [weak view] changes in
            guard let view = view else { return }
            switch changes {
            case .initial:
                view.reloadData()
            case .update(_, let delete, let insert, let update):
                view.beginUpdates()
                view.reloadSections(IndexSet(delete), with: .none)
                view.reloadSections(IndexSet(insert), with: .none)
                view.reloadSections(IndexSet(update), with: .none)
                view.endUpdates()
            case .error(let error):
                print(error.localizedDescription)
            }
        })
        
        return token
    }
    
    static func getTableViewTokenLight<T: Object>(_ array: Results<T>, view: UITableView?) -> NotificationToken {
        let token = array.observe({ [weak view] changes in
            guard let view = view else { return }
            switch changes {
            case .initial:
                view.reloadData()
            case .update:
                view.beginUpdates()
                view.reloadData()
                view.endUpdates()
            case .error(let error):
                print(error.localizedDescription)
            }
        })
        
        return token
    }
    
   static func getCollectionViewToken<T: Object>(_ array: Results<T>, view: UICollectionView?) -> NotificationToken {
        let token = array.observe({ [weak view] changes in
            guard let view = view else { return }
            switch changes {
            case .initial:
                view.reloadData()
            case .update(_, let delete, let insert, let update):
                view.performBatchUpdates({
                    view.deleteItems(at: delete.map({ IndexPath(row: $0, section: 0) }))
                    view.insertItems(at: insert.map({ IndexPath(row: $0, section: 0) }))
                    view.reloadItems(at: update.map({ IndexPath(row: $0, section: 0) }))
                }, completion: nil)
            case .error(let error):
                print(error.localizedDescription)
            }
        })
        
        return token
    }
}

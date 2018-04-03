//
//  MyFriendPhotosReloadedOperation.swift
//  myVKApp
//
//  Created by Natalya on 03/04/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit

class MyFriendsPhotosReloaded: Operation {
    
    private let indexPath: IndexPath
    private weak var view: UICollectionView?
    private var cell: MyFriendCollectionViewCell?
    
    init(indexPath: IndexPath, view: UICollectionView, cell: MyFriendCollectionViewCell) {
        self.indexPath = indexPath
        self.view = view
        self.cell = cell
    }
    
    override func main() {
        guard let view = view,
            let cell = cell,
            let getImageOperation = dependencies[0] as? GetCashedImage,
            let image = getImageOperation.outputImage
            else { return }
        let canvasSize = cell.myFriendPhoto.frame.size.width
        if let newIndexPath = view.indexPath(for: cell), newIndexPath == indexPath {
            cell.myFriendPhoto.image = image.resizeWithWidth(width: canvasSize)
        } else {
            cell.myFriendPhoto.image = nil
        }
    }
}

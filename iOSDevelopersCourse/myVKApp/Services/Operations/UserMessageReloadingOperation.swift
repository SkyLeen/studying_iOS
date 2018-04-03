//
//  UserMessageReloadingOperation.swift
//  myVKApp
//
//  Created by Natalya on 03/04/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit

class UserMessageReloading: Operation {
    
    private let indexPath: IndexPath
    private weak var view: UITableView?
    private var cell: DialogUserMessagesViewCell?
    
    init(indexPath: IndexPath, view: UITableView, cell: DialogUserMessagesViewCell) {
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
        let canvasSize = cell.friendMessageImage.frame.size.width
        if let currentIndexPath = view.indexPath(for: cell), currentIndexPath == indexPath {
            cell.friendMessageImage.image = image.resizeWithWidth(width: canvasSize)
        } else {
            cell.friendMessageImage.image = nil
        }
    }
}

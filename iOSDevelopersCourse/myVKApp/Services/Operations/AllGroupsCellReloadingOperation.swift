//
//  AllGroupsCellReloadingOperation.swift
//  myVKApp
//
//  Created by Natalya on 03/04/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit

class AllGroupsCellReloading: Operation {
    
    private let indexPath: IndexPath
    private weak var view: UITableView?
    private var cell: AllGroupsViewCell?
    
    init(indexPath: IndexPath, view: UITableView, cell: AllGroupsViewCell) {
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
        let canvasSize = cell.allGroupImageView.frame.size.width
        if let newIndexPath = view.indexPath(for: cell), newIndexPath == indexPath {
            cell.allGroupImageView.image = image.resizeWithWidth(width: canvasSize)
        } else {
            cell.allGroupImageView.image = nil
        }
    }
}

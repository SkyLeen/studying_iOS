//
//  NewsAuthorReloadingOperation.swift
//  myVKApp
//
//  Created by Natalya on 03/04/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit

class NewsAuthorReloading: Operation {
    
    private let indexPath: IndexPath
    private weak var view: UITableView?
    private var cell: NewsViewCell?
    
    init(indexPath: IndexPath, view: UITableView, cell: NewsViewCell) {
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
        let canvasSize = cell.authorImage.frame.size.width
        if let newIndexPath = view.indexPath(for: cell), newIndexPath == indexPath {
            cell.authorImage.image = image.resizeWithWidth(width: canvasSize)
        } else {
            cell.authorImage.image = nil
        }
    }
}

//
//  TableCellReloading.swift
//  myVKApp
//
//  Created by Natalya on 06/04/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit

class TableCellReloading: Operation {
    
    private let indexPath: IndexPath
    private weak var view: UITableView?
    private var cell: UITableViewCell?
    private var imageView: UIImageView?
    
    init(indexPath: IndexPath, view: UITableView, cell: UITableViewCell, imageView: UIImageView) {
        self.indexPath = indexPath
        self.view = view
        self.cell = cell
        self.imageView = imageView
    }
    
    override func main() {
        guard let view = view,
            let cell = cell,
            let imageView = imageView,
            let getImageOperation = dependencies[0] as? GetCashedImage,
            let image = getImageOperation.outputImage
            else { return }
        
        let canvasSize = imageView.frame.size.width
        if let currentIndexPath = view.indexPath(for: cell),  currentIndexPath == indexPath {
            imageView.image = image.resizeWithWidth(width: canvasSize)
        } else {
            imageView.image = nil
        }
    }
}

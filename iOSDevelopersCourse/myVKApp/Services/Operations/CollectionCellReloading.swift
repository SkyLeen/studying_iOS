//
//  CollectionCellReloading.swift
//  myVKApp
//
//  Created by Natalya on 06/04/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit

class CollectionCellReloading: Operation {
    
    private let indexPath: IndexPath
    private weak var view: UICollectionView?
    private var cell: UICollectionViewCell?
    private var imageView: UIImageView?
    
    init(indexPath: IndexPath, view: UICollectionView, cell: UICollectionViewCell, imageView: UIImageView) {
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
        if let currentIndexPath = view.indexPath(for: cell), currentIndexPath == indexPath {
            imageView.image = image.resizeWithWidth(width: canvasSize)
        } else {
            imageView.image = nil
        }
    }
}

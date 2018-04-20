//
//  Protocols.swift
//  myVKApp
//
//  Created by Natalya on 12/04/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit

protocol CellHeightDelegate: class {
    func setCellHeight(_ height: CGFloat, at index: IndexPath, cell: UITableViewCell)
}

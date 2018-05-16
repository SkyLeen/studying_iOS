//
//  Layers.swift
//  myVKApp
//
//  Created by Natalya on 12/04/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit

class Layers {
    
    static func getAvatarImageFrame(insets: CGFloat) -> CGRect {
        let rectSide: CGFloat = 45
        let size = CGSize(width: ceil(rectSide), height: ceil(rectSide))
        
        let position = insets
        let origin = CGPoint(x: position, y: position)
        let frame = CGRect(origin: origin, size: size)
        
        return frame
    }
    
    static func getLabelFrame(fromX: CGFloat, fromY: CGFloat, labelSize: CGSize) -> CGRect {
        let positionX = fromX
        let positionY = fromY
        let origin = CGPoint(x: positionX, y: positionY)
        let frame = CGRect(origin: origin, size: labelSize)
        
        return frame
    }
    
    static func getLabelSize(text: String, font: UIFont, in cell: UITableViewCell, insets: CGFloat) -> CGSize {
        let maxWidth = cell.bounds.width - insets
        let maxHeight = CGFloat.greatestFiniteMagnitude
        let textBlock = CGSize(width: maxWidth, height: maxHeight)
        
        let rect = text.boundingRect(with: textBlock, attributes: [NSAttributedStringKey.font: font], context: nil)
        //let width = rect.size.width
        let height = rect.size.height
        
        let labelSize = CGSize(width: ceil(maxWidth), height: ceil(height))
        return labelSize
    }
    
}

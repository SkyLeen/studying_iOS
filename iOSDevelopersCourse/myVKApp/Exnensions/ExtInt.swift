//
//  ExtInt.swift
//  myVKApp
//
//  Created by Natalya on 01/04/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import Foundation

extension Int {
    
    var withSeparator: String {
        return Formatter.withSeparator.string(for: self) ?? ""
    }
}

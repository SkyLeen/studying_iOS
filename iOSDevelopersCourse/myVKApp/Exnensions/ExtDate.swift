//
//  ExtDate.swift
//  myVKApp
//
//  Created by Natalya on 01/04/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import Foundation

extension Date {
    var formatted: String {
        return Formatter.formattedDate.string(from: self)
    }
}

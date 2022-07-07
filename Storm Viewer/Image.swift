//
//  Image.swift
//  Storm Viewer
//
//  Created by Camilo Hernández Guerrero on 3/07/22.
//

import UIKit

class Image: Codable {
    var title: String
    var timesShown: Int = 0
    
    init(title: String) {
        self.title = title
    }
}

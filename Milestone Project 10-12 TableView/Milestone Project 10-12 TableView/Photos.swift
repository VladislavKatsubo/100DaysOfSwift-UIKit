//
//  Photos.swift
//  Milestone Project 10-12 TableView
//
//  Created by Vlad Katsubo on 5/10/22.
//

import UIKit

class Photos: NSObject, Codable {

    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}

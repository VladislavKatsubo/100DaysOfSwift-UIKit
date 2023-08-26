//
//  Photos.swift
//  Milestone Project 10-12
//
//  Created by Vlad Katsubo on 5/9/22.
//

import UIKit

class Photos: NSObject {

    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.image = image
        self.name = name
    }
    
}

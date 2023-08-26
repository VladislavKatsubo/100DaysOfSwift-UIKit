//
//  Contry.swift
//  Milestone Project 13-15
//
//  Created by Vlad Katsubo on 5/22/22.
//

import Foundation

struct Country: Codable {
    var country: String
    var city: String? = "No Capital City"
    var languages: [String]? = [String]()
    var dish: String? = "Big Mac"
}

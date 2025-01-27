//
//  TwitterData.swift
//  Twitter Game
//
//  Created by Olivia Logan on 9/24/20.
//  Copyright © 2020 Olivia Logan. All rights reserved.
//

import Foundation

// Use this model to decode the JSON file
struct TwitterData: Codable {
    let text: String
    let user: User
}

struct User: Codable {
    let name: String
}

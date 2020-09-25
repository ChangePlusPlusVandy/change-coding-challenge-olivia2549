//
//  TwitterModel.swift
//  Twitter Game
//
//  Created by Olivia Logan on 9/24/20.
//  Copyright © 2020 Olivia Logan. All rights reserved.
//

import Foundation

// Twitter data gets stored as an array of TwitterModel objects
struct TwitterModel {
    let text: String
    let name: String
    var computedName: String {
        if (name == "ye") {
            return "Kanye West"
        } else {
            return "Elon Musk"
        }
    }
}

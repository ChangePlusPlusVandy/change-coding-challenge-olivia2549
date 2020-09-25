//
//  GameManager.swift
//  Twitter Game
//
//  Created by Olivia Logan on 9/24/20.
//  Copyright © 2020 Olivia Logan. All rights reserved.
//

import Foundation

protocol GameManagerDelegate {
    func didGenerateTweet(tweetToGuess: String)
}

struct GameManager {
    var delegate: GameManagerDelegate?
    var tweets = [TwitterModel]()
    var tweetToGuess = TwitterModel(text: "", name: "")
    let defaultTweet = TwitterModel(text: "no tweet found", name: "")
    var score = 0
    
    // Take a tweet from the tweets array and pass it to the VC
    mutating func generateTweet() {
        tweetToGuess = tweets.randomElement() ?? defaultTweet
        delegate?.didGenerateTweet(tweetToGuess: tweetToGuess.text)
    }
    
    // Check the user's answer
    mutating func checkAnswer(nameGuessed: String) -> Bool {
        if (tweetToGuess.computedName == nameGuessed) {
            score += 1
            return true
        } else {
            return false
        }
    }
    
    // Reset score and tweets array
    mutating func reset() {
        tweets = [TwitterModel]()
        score = 0
    }
}

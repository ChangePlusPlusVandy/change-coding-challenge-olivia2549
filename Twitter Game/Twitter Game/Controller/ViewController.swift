//
//  ViewController.swift
//  Twitter Game
//
//  Created by Olivia Logan on 9/19/20.
//  Copyright © 2020 Olivia Logan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var correctAnswerLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    var twitterManager = TwitterManager()
    var gameManager = GameManager()
    var questionNum = 0
    var gameOver = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        twitterManager.delegate = self
        gameManager.delegate = self
        
        restart()
    }
    
    // Set all values and labels to the beginning
    func restart() {
        gameManager.reset()
        twitterManager.fetchElonTweets()
        twitterManager.fetchKanyeTweets()
        gameManager.generateTweet()
        
        titleLabel.text = "Who Tweeted This?"
        tweetTextLabel.text = "Click on Elon or Kanye to begin!"
        progressView.progress = 0.0
        progressView.isHidden = false
        questionNum = 0
        correctAnswerLabel.isHidden = true
        gameOver = false
    }
    
    // Set labels to display results
    func displayResults() {
        progressView.isHidden = true
        correctAnswerLabel.isHidden = true
        tweetTextLabel.text = "Your score: \(gameManager.score)/10"
        titleLabel.text = "Click on Elon or Kanye to play again!"
    }

    // User picked their answer
    @IBAction func answerBtnPressed(_ sender: UIButton) {
        if ((questionNum < 10) && !gameOver) {
            if (gameManager.tweetToGuess.text != "no tweet found") {
                questionNum += 1
                progressView.progress = Float(questionNum)/10
                correctAnswerLabel.isHidden = false
                
                let name = sender.title(for: .normal)!
                let isCorrect = gameManager.checkAnswer(nameGuessed: name)
                
                if (isCorrect) {
                    correctAnswerLabel.text = "\(name) is correct!"
                } else {
                    correctAnswerLabel.text = "Incorrect. The right answer is \(gameManager.tweetToGuess.computedName)!"
                }
            }
            
            gameManager.generateTweet()
        } else if gameOver {
            restart()
        } else {
            displayResults()
            gameOver = true
        }
    }
    
}

extension ViewController: TwitterManagerDelegate, GameManagerDelegate {
    // Gets called when GameManager generates a tweet
    func didGenerateTweet(tweetToGuess: String) {
        DispatchQueue.main.async {
            if (tweetToGuess != "no tweet found") {
                self.tweetTextLabel.text = tweetToGuess
            }
        }
    }
    
    // Gets called when TwitterManager fetches tweet data via http request
    func didFetchTweets(_ twitterManager: TwitterManager, fetchedTweets: [TwitterModel]) {
        DispatchQueue.main.async {
            self.gameManager.tweets.append(contentsOf: fetchedTweets)
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

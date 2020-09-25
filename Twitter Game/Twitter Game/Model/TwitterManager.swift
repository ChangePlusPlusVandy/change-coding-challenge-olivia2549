//
//  TwitterManager.swift
//  Twitter Game
//
//  Created by Olivia Logan on 9/19/20.
//  Copyright © 2020 Olivia Logan. All rights reserved.
//

import Foundation

// Any class who conforms to TwitterManagerDelegate must define didFetchTweets() and didFailWithError()
protocol TwitterManagerDelegate {
    func didFetchTweets(_ twitterManager: TwitterManager, fetchedTweets: [TwitterModel])
    func didFailWithError(error: Error)
}

struct TwitterManager {
    // Refers to the class that implements TwitterManagerDelegate
    var delegate: TwitterManagerDelegate?
    
    func fetchElonTweets() {
        let urlString = "https://api.twitter.com/1.1/statuses/user_timeline.json?screen_name=elonmusk&count=3200"
        performRequest(with: urlString)
    }
    
    func fetchKanyeTweets() {
        let urlString = "https://api.twitter.com/1.1/statuses/user_timeline.json?screen_name=kanyewest&count=3200"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            
            // Make the HTTP request
            var request = URLRequest(url: url)
            request.addValue("Bearer AAAAAAAAAAAAAAAAAAAAAKxtHwEAAAAAIg7HqlORKXcEAWzYm%2FZQPKNXoJc%3DCEglCmJ4oGTsAnMYqXp9ISjqwCvX91tbi6xEyA00r1DNzr64OI", forHTTPHeaderField: "Authorization")
            request.addValue("personalization_id=\"v1_FRsbCBjuWSsMl4AyHTI0Jw==\"; guest_id=v1%3A160091815732370591", forHTTPHeaderField: "Cookie")
            request.httpMethod = "GET"
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: request) { data, response, error in
              if error != nil {
                self.delegate?.didFailWithError(error: error!)
                  return
              }
              
              // Get the data
              if let safeData = data {
                // tweets is an array of TwitterModel objects returned after parsing JSON
                  if let tweets = self.parseJSON(safeData) {
                    self.delegate?.didFetchTweets(self, fetchedTweets: tweets)
                  }
              }
            }
            task.resume()
        }
    }
    
    // Decode JSON data to a tweet object
    func parseJSON(_ twitterData: Data) -> [TwitterModel]? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode([TwitterData].self, from: twitterData)
            
            var tweets = [TwitterModel]()
            
            // Fill the tweets array with data by converting to TwitterModel
            for element in decodedData {
                let text = element.text
                if (!text.contains("@") && (!text.contains("http"))) {  // Filter out links and tags
                    let name = element.user.name
                    let tweet = TwitterModel(text: text, name: name)
                    tweets.append(tweet)
                }
            }
            return tweets
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
        
}

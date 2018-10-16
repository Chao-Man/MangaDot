//
//  ReadnowViewModel.swift
//  MangaDot
//
//  Created by Jian Chao Man on 29/9/18.
//  Copyright © 2018 Jian Chao Man. All rights reserved.
//

import Foundation

class ReadnowViewModel {
    
    // MARK: - Types
    
    enum FeedDataError: Error {
        case noFeedDataAvailable
    }
    
    // MARK: - Type Aliases
    
    typealias DidFetchFeedDataCompletion = (FeedData?, FeedDataError?) -> Void
    
    // MARK: - Properties
    
    var didFetchFeedData: DidFetchFeedDataCompletion?
    
    // MARK: - Methods
    
    func fetchFeedData() {
        fetchMangadexFeedData()
    }
    
    private func fetchMangadexFeedData() {
        let feedRequest = MangadexFeedRequest(baseUrl: MangadexService.baseUrl)
        
        URLSession.shared.dataTask(with: feedRequest.url) { [weak self] (data, response, error) in
            if let response = response as? HTTPURLResponse {
                print("Status Code: \(response.statusCode)")
            }
            
            DispatchQueue.main.async {
                if let error = error {
                    print("Unable to Fetch Weather Data \(error)")
                    
                    self?.didFetchFeedData?(nil, .noFeedDataAvailable)
                } else if let data = data {
                    do {
                        // Decode HTML Response
                        let mangadexResponse = try MangadexFeedResponse(data: data)
                        
                        // Invoke Completion Handler
                        self?.didFetchFeedData?(mangadexResponse, nil)
                    } catch {
                        print("Unable to Decode HTML Response \(error)")
                        
                        // Invoke Completion Handler
                        self?.didFetchFeedData?(nil, .noFeedDataAvailable)
                    }
                } else {
                    self?.didFetchFeedData?(nil, .noFeedDataAvailable)
                }
            }
            }.resume()
    }
}

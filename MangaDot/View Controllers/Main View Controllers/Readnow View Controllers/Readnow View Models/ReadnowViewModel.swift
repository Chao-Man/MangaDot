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
    
    typealias DidFetchFeedDataCompletion = () -> Void
    
    // MARK: - Properties
    
    var didFetchFeedData: DidFetchFeedDataCompletion?
    
    func fetchMangadexFeedData() {
        
    }
}

//
//  ReadnowViewModel.swift
//  MangaDot
//
//  Created by Jian Chao Man on 29/9/18.
//  Copyright © 2018 Jian Chao Man. All rights reserved.
//

import Foundation
import PMKFoundation
import PromiseKit

class ReadnowViewModel {
    // MARK: - Types

    enum FeedDataResult {
        case success(FeedData)
        case failure(FeedDataError)
    }

    enum FeedDataError: Error {
        case noFeedDataAvailable
    }

    // MARK: - Type Aliases

    typealias DidFetchFeedDataCompletion = (FeedDataResult) -> Void

    // MARK: - Properties

    var didFetchFeedData: DidFetchFeedDataCompletion?

    // MARK: - Public API

    func fetchFeedData() -> Promise<FeedData> {
        let feedRequest = MangadexFeedRequest(baseUrl: MangadexService.baseUrl)

        return firstly {
            URLSession.shared.dataTask(.promise, with: feedRequest.url)
        }.compactMap {
            return try MangadexFeedResponse(data: $0.data)
        }
    }
}

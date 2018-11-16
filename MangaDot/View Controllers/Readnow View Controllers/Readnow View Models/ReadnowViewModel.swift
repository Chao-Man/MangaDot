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

    func refresh() {
        fetchMangadexFeedData()
    }

    // MARK: - Methods

    private func fetchMangadexFeedData() {
        let feedRequest = MangadexFeedRequest(baseUrl: MangadexService.baseUrl)

        URLSession.shared.dataTask(with: feedRequest.url) { [weak self] data, response, error in
            if let response = response as? HTTPURLResponse {
                print("Status Code: \(response.statusCode)")
            }

            DispatchQueue.main.async {
                if let error = error {
                    print("Unable to Fetch Manga Data \(error)")

                    // Feed Data Result
                    let result: FeedDataResult = .failure(.noFeedDataAvailable)

                    // Invoke Completion Handler
                    self?.didFetchFeedData?(result)

                } else if let data = data {
                    do {
                        // Decode HTML Response
                        let mangadexResponse = try MangadexFeedResponse(data: data)

                        // Feed Data Result
                        let result: FeedDataResult = .success(mangadexResponse)

                        // Invoke Completion Handler
                        self?.didFetchFeedData?(result)
                    } catch {
                        print("Unable to Decode HTML Response \(error)")

                        // Feed Data Result
                        let result: FeedDataResult = .failure(.noFeedDataAvailable)

                        // Invoke Completion Handler
                        self?.didFetchFeedData?(result)
                    }
                } else {
                    // Feed Data Result
                    let result: FeedDataResult = .failure(.noFeedDataAvailable)

                    // Invoke Completion Handler
                    self?.didFetchFeedData?(result)
                }
            }
        }.resume()
    }
}

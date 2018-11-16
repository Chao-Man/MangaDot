//
//  ReaderViewModel.swift
//  MangaDot
//
//  Created by Jian Chao Man on 4/11/18.
//  Copyright © 2018 Jian Chao Man. All rights reserved.
//

import Foundation

class ReaderViewModel {
    let id: Int

    // MARK: - Types

    enum ChapterPageDataError: Error {
        case noChapterPageDataAvailable
    }

    // MARK: - Type Aliases

    typealias DidFetchChapterPageDataCompletion = (ChapterPageData?, ChapterPageDataError?) -> Void

    // MARK: - Properties

    var didFetchChapterPageData: DidFetchChapterPageDataCompletion?

    // MARK: - Methods

    init(id: Int) {
        self.id = id
    }

    func fetchPagesData() {
        fetchMangadexPagesData()
    }

    private func fetchMangadexPagesData() {
        let pagesRequest = MangadexApiRequest(baseUrl: MangadexService.baseApiUrl, type: .chapter, id: String(id))
        var request = URLRequest(url: pagesRequest.url)
        request.setValue("Accept-Encoding", forHTTPHeaderField: "compress, gzip")

        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let response = response as? HTTPURLResponse {
                print("Status Code: \(response.statusCode)")
            }

            DispatchQueue.main.async {
                if let error = error {
                    print("Unable to Fetch Manga Data \(error)")

                    self?.didFetchChapterPageData?(nil, .noChapterPageDataAvailable)
                } else if let data = data {
                    // Initilise JSON Decoder
                    let decoder = JSONDecoder()

                    // Configure JSON Decoder
                    decoder.dateDecodingStrategy = .secondsSince1970
                    decoder.keyDecodingStrategy = .convertFromSnakeCase

                    do {
                        // Decode HTML Response
                        let mangadexChapterResponse = try decoder.decode(MangadexChapterResponse.self, from: data)

                        // Invoke Completion Handler
                        self?.didFetchChapterPageData?(mangadexChapterResponse, nil)
                    } catch {
                        print("Unable to Decode HTML Response \(error)")

                        // Invoke Completion Handler
                        self?.didFetchChapterPageData?(nil, .noChapterPageDataAvailable)
                    }
                } else {
                    self?.didFetchChapterPageData?(nil, .noChapterPageDataAvailable)
                }
            }
        }.resume()
    }
}

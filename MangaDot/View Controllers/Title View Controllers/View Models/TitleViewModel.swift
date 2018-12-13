//
//  TitleViewModel.swift
//  Manga
//
//  Created by Jian Chao Man on 27/9/18.
//  Copyright © 2018 Jian Chao Man. All rights reserved.
//

import Foundation
import PromiseKit
import PMKFoundation

class TitleViewModel {
    // MARK: - Types

    enum TitleDataError: Error {
        case noTitleDataAvailable
    }

    // MARK: - Type Aliases

    typealias DidFetchTitleDataCompletion = (DetailedTitleData?, TitleDataError?) -> Void

    // MARK: - Properties

    var didfetchTitleData: DidFetchTitleDataCompletion?
    var titleId: Int

    init(titleId: Int) {
        self.titleId = titleId
    }
    
    func fetchTitleData() -> Promise<DetailedTitleData> {
        let titleRequest = MangadexApiRequest(
            baseUrl: MangadexService.baseApiUrl,
            type: MangadexService.ApiType.title,
            id: String(titleId)
        )
        return firstly {
            URLSession.shared.dataTask(.promise, with: titleRequest.url)
            }.compactMap{
                // Initilise JSON Decoder
                let decoder = JSONDecoder()
                // Configure JSON Decoder
                decoder.dateDecodingStrategy = .secondsSince1970
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                return try decoder.decode(MangadexTitleResponse.self, from: $0.data)
        }
    }
}

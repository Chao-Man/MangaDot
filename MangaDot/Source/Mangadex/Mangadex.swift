//
//  Mangadex.swift
//  MangaDot
//
//  Created by Jian Chao Man on 2/1/19.
//  Copyright © 2019 Jian Chao Man. All rights reserved.
//

import Foundation
import PMKFoundation
import PromiseKit

public class Mangadex: SourceProtocol {
    static let baseUrl = URL(string: "https://mangadex.org")!
    static let baseApiUrl = baseUrl.appendingPathComponent("api")

    enum ServiceType: String {
        case title = "manga"
        case chapter
    }

    enum Errors: Error {
        case invalidDataFormat
        case invalidTitleId
        case invalidCoverUrl
    }

    // Mangadex URL endpoints
    internal struct url {
        static func feed() -> URL {
            return baseUrl
        }

        static func title(id: Int) -> URL {
            return URL(string: "\(baseApiUrl.absoluteString)/?id=\(id)&type=\(ServiceType.title.rawValue)")!
        }

        static func chapter(id: Int) -> URL {
            return URL(string: "\(baseApiUrl.absoluteString)/?id=\(id)&type=\(ServiceType.chapter.rawValue)")!
        }
    }

    // MARK: - Public Methods

    func fetchFeed() -> Promise<FeedProtocol> {
        return firstly {
            URLSession.shared.dataTask(.promise, with: url.feed())
        }.compactMap {
            try Feed(data: $0.data)
        }
    }

    func fetchTitleInfo(id: Int) -> Promise<TitleInfoProtocol> {
        var request = URLRequest(url: url.title(id: id))
        request.setValue("Accept-Encoding", forHTTPHeaderField: "compress, gzip")
        
        return firstly {
            URLSession.shared.dataTask(.promise, with: request)
        }.compactMap {
            try Mangadex.TitleInfo(withId: id, data: $0.data)
        }
    }
}

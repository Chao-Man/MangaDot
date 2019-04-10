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
    static let baseDomain = URL(string: "mangadex.org")!
    static let baseUrl = URL(string: "https://mangadex.org")!
    static let dataUrl = baseUrl.appendingPathComponent("data")
    static let baseApiUrl = baseUrl.appendingPathComponent("api")

    enum ServiceType: String {
        case title = "manga"
        case chapter
    }

    enum Errors: Error {
        case invalidDataFormat
        case invalidTitleId
        case invalidCoverUrl
        case invalidHttpResponse
        case cloudflareProtection
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
    
    func name() -> String {
        return "MangaDex"
    }

    func fetchFeed() -> Promise<FeedProtocol> {
        return firstly {
            URLSession.shared.dataTask(.promise, with: url.feed())
        }.compactMap {
            guard let httpUrlResponse = $0.response as? HTTPURLResponse else { throw Errors.invalidHttpResponse }
            guard httpUrlResponse.statusCode != 503 else { throw Errors.cloudflareProtection }
            guard httpUrlResponse.statusCode == 200 else { throw Errors.invalidHttpResponse }
            return try Feed(data: $0.data)
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
    
    func fetchChapter(id: Int) -> Promise<DetailedChapterProtocol> {
        print("Mangadex.swift | Fetching chapter with id: \(id)")
        
        var request = URLRequest(url: url.chapter(id: id))
        request.setValue("Accept-Encoding", forHTTPHeaderField: "compress, gzip")
        
        return firstly {
            URLSession.shared.dataTask(.promise, with: request)
            }.compactMap {
            try Mangadex.Chapter(withId: id, data: $0.data)
        }
    }
}

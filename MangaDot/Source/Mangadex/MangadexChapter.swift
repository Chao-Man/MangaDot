//
//  MangadexChapter.swift
//  MangaDot
//
//  Created by Jian Chao Man on 14/2/19.
//  Copyright © 2019 Jian Chao Man. All rights reserved.
//

import Foundation

extension Mangadex {
    class Chapter: DetailedChapterProtocol {
        // MARK: - Instance Properties
        
        let decoded: CustomDecodable
        let id: Int
        
        // MARK: - Computed Instance Properties
        
        lazy var timestamp: Date = {
            return decoded.timestamp
        }()
        
        lazy var hash: String = {
            return decoded.hash
        }()
        
        lazy var langName: String = {
            return decoded.langName
        }()
        
        lazy var mangaId: Int = {
            return decoded.mangaId
        }()
        
        lazy var comments: Int? = {
            return decoded.comments
        }()
        
        lazy var server: URL = {
            return decoded.server
        }()
        
        lazy var pageUrlArray: [URL] = {
            return decoded.pageArray.compactMap {
                server.appendingPathComponent(hash).appendingPathComponent($0!.absoluteString)
            }
        }()
        
        lazy var longStrip: Int8 = {
            return decoded.longStrip
        }()
        
        lazy var status: String = {
            return decoded.status
        }()
        
        lazy var volume: String = {
            return decoded.volume
        }()
        
        lazy var chapter: String = {
            return decoded.chapter
        }()
        
        lazy var title: String = {
            return decoded.title
        }()
        
        lazy var langCode: String = {
            return decoded.langCode
        }()
        
        lazy var groupId: Int = {
            return decoded.groupId
        }()
        
        lazy var groupId2: Int = {
            return decoded.groupId2
        }()
        
        lazy var groupId3: Int = {
            return decoded.groupId3
        }()
        
        // MARK: - Life Cycle
        
        init(withId id: Int, data: Data) throws {
            self.id = id
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .secondsSince1970
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoded = try decoder.decode(CustomDecodable.self, from: data)
        }
        
        // MARK: - Decodable Structure
        
        struct CustomDecodable: Decodable {
            let id: Int
            let timestamp: Date
            let hash: String
            let langName: String
            let mangaId: Int
            let comments: Int?
            let server: URL
            let pageArray: [URL?]
            let longStrip: Int8
            let status: String
            let volume: String
            let chapter: String
            let title: String
            let langCode: String
            let groupId: Int
            let groupId2: Int
            let groupId3: Int
        }
    }
}

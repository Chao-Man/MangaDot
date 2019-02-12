//
//  MangadexTitleInfo.swift
//  MangaDot
//
//  Created by Jian Chao Man on 12/1/19.
//  Copyright © 2019 Jian Chao Man. All rights reserved.
//

import Foundation

extension Mangadex {
    class TitleInfo: TitleInfoProtocol {
        // MARK: - Instance Properties

        let decoded: CustomDecodable
        let id: Int

        // MARK: - Computed Instance Properties

        lazy var coverUrl: URL? = {
            let fullPath = self.decoded.manga.coverUrl
            let pathArray = fullPath.components(separatedBy: "?")
            guard let pathWithRemovedTimestamp = pathArray.first else { return nil }
            return URL(string: "\(Mangadex.baseUrl)\(pathWithRemovedTimestamp)")
        }()

        lazy var largeCoverUrl: URL? = {
            coverUrl
        }()

        lazy var title: String = {
            self.decoded.manga.title.decodingHTMLEntities()
        }()

        lazy var description: String = {
            self.decoded.manga.description.decodingHTMLEntities()
        }()

        lazy var artist: String = {
            self.decoded.manga.artist.decodingHTMLEntities()
        }()

        lazy var author: String = {
            self.decoded.manga.author.decodingHTMLEntities()
        }()

        lazy var status: Int8 = {
            self.decoded.manga.status
        }()

        lazy var genres: [Int8] = {
            self.decoded.manga.genres
        }()

        lazy var lastChapter: String = {
            self.decoded.manga.lastChapter
        }()

        lazy var langName: String = {
            self.decoded.manga.langName
        }()

        lazy var langFlag: String = {
            self.decoded.manga.langFlag
        }()

        lazy var chapters: [BasicChapterProtocol] = {
            var chaptersWithId: [BasicChapterProtocol] = []
            // Store key inside of Chapter object as id.
            self.decoded.chapter.forEach { (key: Int, decoded: CustomDecodable.Chapter) in
                let chapterWithId = Chapter(id: key, decoded: decoded)
                chaptersWithId.append(chapterWithId)
            }
            return chaptersWithId
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
            struct Chapter: Decodable {
                let volume: String
                let chapter: String
                let title: String
                let langCode: String
                let groupId: Int
                let groupName: String?
                let groupId2: Int
                let groupName2: String?
                let groupId3: Int
                let groupName3: String?
                let timestamp: Date
            }

            struct Manga: Decodable {
                let coverUrl: String
                let description: String
                let title: String
                let artist: String
                let author: String
                let status: Int8
                let genres: [Int8]
                let lastChapter: String
                let langName: String
                let langFlag: String
            }

            let manga: Manga
            let chapter: [Int: Chapter]
        }

        // MARK: - Chapter Structure

        struct Chapter: BasicChapterProtocol {
            let id: Int
            let volume: String
            let chapter: String
            let title: String
            let langCode: String
            let groupId: Int
            let groupName: String?
            let groupId2: Int
            let groupName2: String?
            let groupId3: Int
            let groupName3: String?
            let timestamp: Date

            init(id: Int, decoded: CustomDecodable.Chapter) {
                self.id = id
                volume = decoded.volume
                chapter = decoded.chapter
                title = decoded.title.decodingHTMLEntities()
                langCode = decoded.langCode
                groupId = decoded.groupId
                groupName = decoded.groupName?.decodingHTMLEntities()
                groupId2 = decoded.groupId2
                groupName2 = decoded.groupName2?.decodingHTMLEntities()
                groupId3 = decoded.groupId3
                groupName3 = decoded.groupName3?.decodingHTMLEntities()
                timestamp = decoded.timestamp
            }
        }
    }
}

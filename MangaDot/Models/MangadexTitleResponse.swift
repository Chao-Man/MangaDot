//
//  MangadexTitleResponse.swift
//  Manga
//
//  Created by Jian Chao Man on 24/9/18.
//  Copyright © 2018 Jian Chao Man. All rights reserved.
//

import Foundation

// MARK: - Response Data Structures

struct MangadexTitleResponse: Codable {
    struct Chapter: Codable {
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

    struct Manga: Codable {
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

// MARK: - Extensions

extension MangadexTitleResponse: DetailedTitleData {
    var largeCoverUrl: URL? {
        return URL(string: MangadexService.baseUrl.absoluteString + manga.coverUrl)
    }

    var id: Int? {
        let idString = coverUrl.absoluteString
            .replacingOccurrences(of: "/images/manga/", with: "")
            .replacingOccurrences(of: ".jpg", with: "")
        return Int(idString)
    }

    func chapters(withLanguage langCode: String, orderBy: OrderBy) -> [TitleChapterData] {
        switch orderBy {
        case .ascending:
            return chapters
                .filter { $0.langCode == langCode }
                .sorted(by: { ($0.chapter as NSString).floatValue > ($1.chapter as NSString).floatValue })
        case .descending:
            return chapters
                .filter { $0.langCode == langCode }
                .sorted(by: { ($0.chapter as NSString).floatValue < ($1.chapter as NSString).floatValue })
        }
    }

    var coverUrl: URL {
        let largeCover = manga.coverUrl.replacingOccurrences(of: ".jpg", with: ".large.jpg")
        return URL(string: MangadexService.baseUrl.absoluteString + largeCover)!
    }

    var description: String {
        return manga.description
    }

    var title: String {
        return manga.title
    }

    var artist: String {
        return manga.artist
    }

    var author: String {
        return manga.author
    }

    var status: Int8 {
        return manga.status
    }

    var genres: [Int8] {
        return manga.genres
    }

    var lastChapter: String {
        return manga.lastChapter
    }

    var langName: String {
        return manga.langName
    }

    var langFlag: String {
        return manga.langFlag
    }

    // TODO: - Implement ChapterWithId functionality for Mangadex as a Decodable class instead of a separate Struct

    var chapters: [TitleChapterData] {
        struct ChapterDetailsWithId: TitleChapterData {
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

            init(id: Int, value: MangadexTitleResponse.Chapter) {
                self.id = id
                volume = value.volume
                chapter = value.chapter
                title = value.title
                langCode = value.langCode
                groupId = value.groupId
                groupName = value.groupName
                groupId2 = value.groupId2
                groupName2 = value.groupName2
                groupId3 = value.groupId3
                groupName3 = value.groupName3
                timestamp = value.timestamp
            }
        }

        var chaptersWithId: [TitleChapterData] = []

        // Store key inside of Chapter object as id.
        chapter.forEach { (key: Int, value: MangadexTitleResponse.Chapter) in
            let chapterWithId = ChapterDetailsWithId(
                id: key,
                value: value
            )
            chaptersWithId.append(chapterWithId)
        }
        return chaptersWithId
    }
}

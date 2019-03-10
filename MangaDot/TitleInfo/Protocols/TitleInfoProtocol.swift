//
//  TitleInfoProtocol.swift
//  MangaDot
//
//  Created by Jian Chao Man on 12/1/19.
//  Copyright © 2019 Jian Chao Man. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

protocol TitleInfoProtocol {
    var id: Int { get }
    var coverUrl: URL? { get }
    var largeCoverUrl: URL? { get }
    var title: String { get }
    var description: String { get }
    var artist: String { get }
    var author: String { get }
    var status: Int8 { get }
    var genres: [Int8] { get }
    var lastChapter: String { get }
    var langName: String { get }
    var langFlag: String { get }
    var chapters: [BasicChapterProtocol] { get }
}

extension TitleInfoProtocol {
    func persist(source: String) -> TitleInfoPersist? {
        let persistBuilder = TitleInfoPersistBuilder { builder in
            builder.source = source
            builder.titleId = id
            builder.coverString = coverUrl?.absoluteString
            builder.largeCoverString = largeCoverUrl?.absoluteString
            builder.title = title
            builder.titleDescription = description
            builder.artist = artist
            builder.author = author
            builder.status = status
            builder.genres = genres
            builder.lastChapter = lastChapter
            builder.langName = langName
            builder.langFlag = langFlag
            builder.chapters = chapters
        }

        return TitleInfoPersist(builder: persistBuilder)
    }
    
    // MARK: - Functions
    func chapters(sortUsing: Sources.Sorting.Attribute, orderBy order: Sources.Sorting.OrderBy, langCode: String) -> [BasicChapterProtocol] {
        let chapters = self.chapters(withLangCode: langCode)
        switch sortUsing {
        case .chapter:
            return chaptersSortedByChapter(chapters: chapters, orderBy: order)
        case .volume:
            return chaptersSortedByVolume(chapters: chapters, orderBy: order)
        case .recent:
            return chaptersSortedByRecent(chapters: chapters, orderBy: order)
        case .title:
            return chaptersSortedByTitle(chapters: chapters, orderBy: order)
        case.volumeAndChapter:
            return chaptersSortedByVolumeAndChapter(chapters: chapters, orderBy: order)
        }
    }
    
    func numberOfChapters(withLangCode langCode: String) -> Int {
        return chapters(withLangCode: langCode).count
    }
    
    private func chapters(withLangCode langCode: String) -> [BasicChapterProtocol] {
        return chapters.filter { $0.langCode == langCode }
    }
    
    private func chaptersSortedByChapter(chapters: [BasicChapterProtocol], orderBy: Sources.Sorting.OrderBy) -> [BasicChapterProtocol] {
        switch orderBy {
        case .ascending:
            return chapters.sorted { $0.chapterFloat() < $1.chapterFloat() }
        case .descending:
            return chapters.sorted { $0.chapterFloat() > $1.chapterFloat() }
        }
    }
    
    private func chaptersSortedByVolume(chapters: [BasicChapterProtocol], orderBy: Sources.Sorting.OrderBy) -> [BasicChapterProtocol] {
        switch orderBy {
        case .ascending:
            return chapters.sorted { $0.volumeFloat() < $1.volumeFloat() }
        case .descending:
            return chapters.sorted { $0.volumeFloat() > $1.volumeFloat() }
        }
    }
    
    private func chaptersSortedByRecent(chapters: [BasicChapterProtocol], orderBy: Sources.Sorting.OrderBy) -> [BasicChapterProtocol] {
        switch orderBy {
        case .ascending:
            return chapters.sorted { $0.timestamp < $1.timestamp }
        case .descending:
            return chapters.sorted { $0.timestamp > $1.timestamp }
        }
    }
    
    private func chaptersSortedByTitle(chapters: [BasicChapterProtocol], orderBy: Sources.Sorting.OrderBy) -> [BasicChapterProtocol] {
        switch orderBy {
        case .ascending:
            return chapters.sorted { $0.title < $1.title }
        case .descending:
            return chapters.sorted { $0.title > $1.title }
        }
    }
    
    private func chaptersSortedByVolumeAndChapter(chapters: [BasicChapterProtocol], orderBy: Sources.Sorting.OrderBy) -> [BasicChapterProtocol] {
        switch orderBy {
        case .ascending:
            return chapters.sorted {
                if $0.volumeFloat() != $1.volumeFloat() {
                    return $0.volumeFloat() < $1.volumeFloat()
                }
                else {
                    return $0.chapterFloat() < $1.chapterFloat()
                }
            }
        case .descending:
            return chapters.sorted {
                if $0.volumeFloat() != $1.volumeFloat() {
                    return $0.volumeFloat() > $1.volumeFloat()
                }
                else {
                    return $0.chapterFloat() > $1.chapterFloat()
                }
            }
        }
    }
}

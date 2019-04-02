//
//  TitleInfoPersist.swift
//  MangaDot
//
//  Created by Jian Chao Man on 13/1/19.
//  Copyright © 2019 Jian Chao Man. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class TitleInfoPersistBuilder {
    var source: String?
    var titleId: Int?
    var coverString: String?
    var largeCoverString: String?
    var title: String?
    var titleDescription: String?
    var artist: String?
    var author: String?
    var status: Int8?
    var genres: [Int8]?
    var lastChapter: String?
    var langName: String?
    var langFlag: String?
    var chapters: [BasicChapterProtocol]?

    typealias BuilderClosure = (TitleInfoPersistBuilder) -> Void

    init(buildClosure: BuilderClosure) {
        buildClosure(self)
    }
}

class TitleInfoPersist: Object {
    // MARK: - Instance Properties

    @objc dynamic var source: String = ""
    @objc dynamic var titleId: Int = 0
    @objc dynamic var coverString: String?
    @objc dynamic var largeCoverString: String?
    @objc dynamic var title: String = ""
    @objc dynamic var titleDescription: String = ""
    @objc dynamic var artist: String = ""
    @objc dynamic var author: String = ""
    @objc dynamic var status: Int8 = 0
    @objc dynamic var lastChapter: String = ""
    @objc dynamic var langName: String = ""
    @objc dynamic var langFlag: String = ""
    var genres = List<Int8>()
    var chapters = List<BasicChapterPersist>()

    // MARK: - Life Cycle

    convenience init?(builder: TitleInfoPersistBuilder) {
        self.init()
        
        guard let source = builder.source,
            let titleId = builder.titleId,
            let coverString = builder.coverString,
            let largeCoverString = builder.largeCoverString,
            let title = builder.title,
            let titleDescription = builder.titleDescription,
            let artist = builder.artist,
            let author = builder.author,
            let status = builder.status,
            let genres = builder.genres,
            let lastChapter = builder.lastChapter,
            let langName = builder.langName,
            let langFlag = builder.langFlag,
            let chapters = builder.chapters
        else { return nil }
        
        self.source = source
        self.titleId = titleId
        self.coverString = coverString
        self.largeCoverString = largeCoverString
        self.title = title
        self.titleDescription = titleDescription
        self.artist = artist
        self.author = author
        self.status = status
        self.lastChapter = lastChapter
        self.langName = langName
        self.langFlag = langFlag
        
        genres.forEach {
            self.genres.append($0)
        }

        chapters.compactMap {
            return $0.persist()
        }.forEach {
             self.chapters.append($0)
        }
    }
    
    override static func primaryKey() -> String? {
        return "titleId"
    }
    
    var coverUrl: URL? {
        guard let coverString = coverString else { return nil }
        return URL(string: coverString)
    }
    
    var largeCoverUrl: URL? {
        guard let largeCoverString = largeCoverString else { return nil }
        return URL(string: largeCoverString)
    }
}

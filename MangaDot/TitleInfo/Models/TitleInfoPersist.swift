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
    var titleId: Int?
    var coverUrl: URL?
    var largeCoverUrl: URL?
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

    @objc dynamic var titleId: Int
    @objc dynamic var coverUrl: URL?
    @objc dynamic var largeCoverUrl: URL?
    @objc dynamic var title: String
    @objc dynamic var titleDescription: String
    @objc dynamic var artist: String
    @objc dynamic var author: String
    @objc dynamic var status: Int8
    @objc dynamic var genres: [Int8]
    @objc dynamic var lastChapter: String
    @objc dynamic var langName: String
    @objc dynamic var langFlag: String
    var chapters = List<BasicChapterPersist>()

    // MARK: - Life Cycle

    init?(builder: TitleInfoPersistBuilder) {
        guard let titleId = builder.titleId,
            let coverUrl = builder.coverUrl,
            let largeCoverUrl = builder.largeCoverUrl,
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

        self.titleId = titleId
        self.coverUrl = coverUrl
        self.largeCoverUrl = largeCoverUrl
        self.title = title
        self.titleDescription = titleDescription
        self.artist = artist
        self.author = author
        self.status = status
        self.genres = genres
        self.lastChapter = lastChapter
        self.langName = langName
        self.langFlag = langFlag

        super.init()

        chapters.forEach {
            self.chapters.append($0.persist()!)
        }
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    required init(realm _: RLMRealm, schema _: RLMObjectSchema) {
        fatalError("init(realm:schema:) has not been implemented")
    }

    required init(value _: Any, schema _: RLMSchema) {
        fatalError("init(value:schema:) has not been implemented")
    }
}

//
//  BasicChapterPersist.swift
//  MangaDot
//
//  Created by Jian Chao Man on 13/1/19.
//  Copyright © 2019 Jian Chao Man. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class BasicChapterPersistBuilder {
    var chapterId: Int?
    var groupName: String?
    var groupName2: String?
    var groupName3: String?
    var timestamp: Date?
    var volume: String?
    var chapter: String?
    var title: String?
    var langCode: String?
    var groupId: Int?
    var groupId2: Int?
    var groupId3: Int?

    typealias BuilderClosure = (BasicChapterPersistBuilder) -> Void

    init(buildClosure: BuilderClosure) {
        buildClosure(self)
    }
}

class BasicChapterPersist: Object {
    @objc dynamic var chapterId: Int = 0
    @objc dynamic var groupName: String?
    @objc dynamic var groupName2: String?
    @objc dynamic var groupName3: String?
    @objc dynamic var timestamp: Date = Date()
    @objc dynamic var volume: String = "0"
    @objc dynamic var chapter: String = "0"
    @objc dynamic var title: String = ""
    @objc dynamic var langCode: String = ""
    @objc dynamic var groupId: Int = 0
    @objc dynamic var groupId2: Int = 0
    @objc dynamic var groupId3: Int = 0

    init?(builder: BasicChapterPersistBuilder) {
        guard let chapterId = builder.chapterId,
            let groupName = builder.groupName,
            let groupName2 = builder.groupName2,
            let groupName3 = builder.groupName3,
            let timestamp = builder.timestamp,
            let volume = builder.volume,
            let chapter = builder.chapter,
            let title = builder.title,
            let langCode = builder.langCode,
            let groupId = builder.groupId,
            let groupId2 = builder.groupId2,
            let groupId3 = builder.groupId3
        else { return nil }

        self.chapterId = chapterId
        self.groupName = groupName
        self.groupName2 = groupName2
        self.groupName3 = groupName3
        self.timestamp = timestamp
        self.volume = volume
        self.chapter = chapter
        self.title = title
        self.langCode = langCode
        self.groupId = groupId
        self.groupId2 = groupId2
        self.groupId3 = groupId3

        super.init()
    }

    required init() {
        super.init()
//        fatalError("init() has not been implemented")
    }

    required init(realm _: RLMRealm, schema _: RLMObjectSchema) {
        fatalError("init(realm:schema:) has not been implemented")
    }

    required init(value _: Any, schema _: RLMSchema) {
        fatalError("init(value:schema:) has not been implemented")
    }
}

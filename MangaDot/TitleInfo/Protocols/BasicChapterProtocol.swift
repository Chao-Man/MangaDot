//
//  BasicChapterProtocol.swift
//  MangaDot
//
//  Created by Jian Chao Man on 12/1/19.
//  Copyright © 2019 Jian Chao Man. All rights reserved.
//

import Foundation

public protocol BasicChapterProtocol {
    var id: Int { get }
    var groupName: String? { get }
    var groupName2: String? { get }
    var groupName3: String? { get }
    var timestamp: Date { get }
    var volume: String { get }
    var chapter: String { get }
    var title: String { get }
    var langCode: String { get }
    var groupId: Int { get }
    var groupId2: Int { get }
    var groupId3: Int { get }
}

extension BasicChapterProtocol {
    func chapterFloat() -> Float {
        guard let chapterFloat = Float(chapter) else { return 0 }
        return chapterFloat
    }
    
    func volumeFloat() -> Float {
        guard let volumeFloat = Float(volume) else { return Float.greatestFiniteMagnitude }
        return volumeFloat
    }
    
    func persist() -> BasicChapterPersist? {
        let persistBuilder = BasicChapterPersistBuilder { builder in
            builder.chapterId = self.id
            builder.groupName = self.groupName
            builder.groupName2 = self.groupName2
            builder.groupName3 = self.groupName3
            builder.timestamp = self.timestamp
            builder.chapter = self.chapter
            builder.volume = self.volume
            builder.title = self.title
            builder.langCode = self.langCode
            builder.groupId = self.groupId
            builder.groupId2 = self.groupId2
            builder.groupId3 = self.groupId3
        }

        return BasicChapterPersist(builder: persistBuilder)
    }
}

//
//  ReaderViewModel.swift
//  MangaDot
//
//  Created by Jian Chao Man on 14/2/19.
//  Copyright © 2019 Jian Chao Man. All rights reserved.
//

import Foundation
import Nuke
import PromiseKit

class ReaderViewModel {
    
    private let pipeline = Current.nukeConfig.readerImagePipelne
    private let preheater = ImagePreheater()
    
    private let source: SourceProtocol
    private var chapters: [ReaderChapterViewModel] = []
    
    private let incrementChapter: (Int) -> Int
    private let decrementChapter: (Int) -> Int
    
    enum Errors: Error {
        case chapterWithIdDoesNotExist
        case chapterIndexOutOfRange
        case reachedEndOfTitle
        case reachedStartOfTitle
    }
    
    init(source: SourceProtocol, basicChaptersOrdered: [BasicChapterProtocol], chapterOrder: SortOrder) {
        self.source = source
        self.chapters = basicChaptersOrdered.enumerated().map {
            return ReaderChapterViewModel(index: $0, source: source, basicChapter: $1)
        }
        switch (chapterOrder) {
            case .ascending:
                incrementChapter = { $0 + 1 }
                decrementChapter = { $0 - 1 }
            case .descending:
                incrementChapter = { $0 - 1 }
                decrementChapter = { $0 + 1 }
        }
    }
    
    func numChapters() -> Int {
        return chapters.count
    }
    
    func chapter(withIndex index: Int) throws -> ReaderChapterViewModel {
        if !isChapterIndexValid(index: index) {
            throw Errors.chapterIndexOutOfRange
        }
        return chapters[index]
    }
    
    func chapter(beforeIndex index: Int) throws -> ReaderChapterViewModel {
        do {
            return try chapter(withIndex: decrementChapter(index))
        } catch {
            throw Errors.reachedEndOfTitle
        }
    }
    
    func chapter(afterIndex index: Int) throws -> ReaderChapterViewModel {
        do {
            return try chapter(withIndex: incrementChapter(index))
        } catch {
            throw Errors.reachedStartOfTitle
        }
    }
    
    // MARK: - Helper Methods
    
    private func isChapterIndexValid(index: Int) -> Bool {
        return index >= 0 && index < chapters.count
    }
}

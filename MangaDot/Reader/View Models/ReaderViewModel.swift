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
import Realm
import RealmSwift

class ReaderChapterViewModel {
    
    let source: SourceProtocol
    let basicChapter: BasicChapterProtocol
    let index: Int
    let preheater = ImagePreheater()
    
    var chapterId: Int {
        get {
            return basicChapter.id
        }
    }
    
    var detailedChapter: DetailedChapterProtocol?
    
    enum Errors: Error {
        case pageIndexOutOfRange
    }
    
    init(index: Int, source: SourceProtocol, basicChapter: BasicChapterProtocol) {
        self.index = index
        self.source = source
        self.basicChapter = basicChapter
    }
    
    // MARK: - Methods
    
    func fetch() -> Promise<Void> {
        return firstly {
            source.fetchChapter(id: basicChapter.id)
        }.done {
            self.detailedChapter = $0
        }
    }

    func pageCount() -> Int {
        guard let detailedChapter = self.detailedChapter else { return 0 }
        return detailedChapter.pageUrlArray.count
    }
    
    func pageImageUrl(atIndex index: Int) -> URL? {
        guard let url = self.detailedChapter?.pageUrlArray[index],
            isInValidRange(index: index, withArrayLength: pageCount()) else {
            return nil
        }
        return url
    }
    
    func startPreloading() {
        guard let detailedChapter = detailedChapter else { return }
        preheater.startPreheating(with: detailedChapter.pageUrlArray)
        print("Preloading \(index)")
    }
    
    func stopPreloading() {
        preheater.stopPreheating()
        print("Stopped preloading \(index)")
    }
    
    // MARK: - Helper Methods
    
    func isInValidRange(index: Int, withArrayLength arrayLength: Int) -> Bool {
        return index >= 0 && index <= arrayLength
    }
}

class Checkpoint: Object {
    @objc dynamic private let titleId: Int
    @objc dynamic var currentPageIndex: Int
    @objc dynamic var currentChapterId: Int
    
    init(titleId: Int, currentChapterId: Int, currentPageIndex: Int = 0) {
        self.titleId = titleId
        self.currentChapterId = currentChapterId
        self.currentPageIndex = currentPageIndex
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        fatalError("init(realm:schema:) has not been implemented")
    }
    
    required init(value: Any, schema: RLMSchema) {
        fatalError("init(value:schema:) has not been implemented")
    }
}

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
    
//    private func chapter(withId id: Int) -> ReaderChapterViewModel {
//        return chapters.first(where: {$0.chapterId == id})
//    }
}

/*
 ChapterCoordinator handles fetching and caching of detailedChapters.
 ChapterCoordinator functions
 
 setNextChapter(), ChapterCoordinator will now operate using next chapter details. current chapter will
 setPrevChapter()
 numPages(), number of pages in current chapter
 page(atIndex index
*/

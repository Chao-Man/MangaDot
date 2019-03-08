//
//  ReaderChapterViewModel.swift
//  MangaDot
//
//  Created by Jian Chao Man on 8/3/19.
//  Copyright © 2019 Jian Chao Man. All rights reserved.
//

import Foundation
import Nuke
import PromiseKit

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

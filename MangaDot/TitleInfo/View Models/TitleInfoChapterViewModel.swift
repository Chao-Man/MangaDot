//
//  TitleInfoChapterViewModel.swift
//  MangaDot
//
//  Created by Jian Chao Man on 10/2/19.
//  Copyright © 2019 Jian Chao Man. All rights reserved.
//

import Foundation
import SwiftDate

class TitleInfoChapterViewModel {
    private let chapterData: BasicChapterProtocol
    
    init(chapterData: BasicChapterProtocol) {
        self.chapterData = chapterData
    }
    
    func title() -> String {
        return chapterData.title
    }
    
    func group() -> String {
        guard let groupName = chapterData.groupName else { return "" }
        return groupName
    }
    
    func chapterNumber() -> String {
        return chapterData.chapter == "" ? "-" : chapterData.chapter
    }
    
    func volumeNumber() -> String {
        return chapterData.volume == "" ? "-" : chapterData.volume
    }
    
    func lastUpdated() -> String {
        return chapterData.timestamp.toRelative()
    }
}

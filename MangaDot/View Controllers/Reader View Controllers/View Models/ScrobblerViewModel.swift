//
//  ScrobblerViewModel.swift
//  MangaDot
//
//  Created by Jian Chao Man on 30/11/18.
//  Copyright © 2018 Jian Chao Man. All rights reserved.
//

import Foundation

struct ScrobblerViewModel {
    // MARK: - Properties

    typealias DidSelectCellCompletion = (Int) -> Void

    var didSelectCell: DidSelectCellCompletion?

    let chapterData: ChapterPageData

    // MARK: - Methods

    init(chapterData: ChapterPageData) {
        self.chapterData = chapterData
    }

    func pageUrls() -> [URL?] {
        return chapterData.pageUrlArray
    }

    func numberOfPages() -> Int {
        return chapterData.pageUrlArray.count
    }

    func pageImageUrl(index: Int) -> URL? {
        return chapterData.pageUrlArray[index]
    }

    func selectCell(index: Int) {
        didSelectCell?(index)
    }
}

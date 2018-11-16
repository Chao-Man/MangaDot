//
//  ChapterViewModel.swift
//  MangaDot
//
//  Created by Jian Chao Man on 9/10/18.
//  Copyright © 2018 Jian Chao Man. All rights reserved.
//

import Foundation

struct TitleChapterViewModel {
    let titleData: DetailedTitleData
    let chapters: [TitleChapterData]

    init(titleData: DetailedTitleData) {
        self.titleData = titleData
        chapters = self.titleData.chapters(withLanguage: "gb", orderBy: OrderBy.ascending)
    }

    func numberOfChapters() -> Int {
        return chapters.count
    }

    func chapter(index: Int) -> TitleChapterData {
        return chapters[index]
    }
}

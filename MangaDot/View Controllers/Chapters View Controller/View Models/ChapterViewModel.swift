//
//  ChapterViewModel.swift
//  MangaDot
//
//  Created by Jian Chao Man on 9/10/18.
//  Copyright © 2018 Jian Chao Man. All rights reserved.
//

import Foundation

struct ChapterViewModel {
    let titleData: DetailedTitleData
    let chapters: [TitleChapterData]
    
    init(titleData: DetailedTitleData) {
        self.titleData = titleData
        self.chapters = self.titleData.chapters(withLanguage: "gb", orderBy: OrderBy.ascending)
    }
    
    func numberOfChapters() -> Int {
        return self.chapters.count
    }
    
    func chapter(index: Int) -> TitleChapterData {
        return chapters[index]
    }
}

//
//  CarouselViewModel.swift
//  Manga
//
//  Created by Jian Chao Man on 27/9/18.
//  Copyright © 2018 Jian Chao Man. All rights reserved.
//

import Foundation

struct CarouselViewModel {
    typealias PushTitle = (Int?, String?) -> Void
    
    let sectionData: SectionData
    var pushTitle: PushTitle?
    
    func sectionName() -> String {
        return sectionData.sectionName
    }
    
    func numberOfTitles() -> Int {
        return sectionData.titleList.count
    }
    
    func titleData(index: Int) -> TitleData {
        return sectionData.titleList[index]
    }
}

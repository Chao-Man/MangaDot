//
//  TitleDescriptionViewModel
//  MangaDot
//
//  Created by Jian Chao Man on 15/11/18.
//  Copyright © 2018 Jian Chao Man. All rights reserved.
//

import Foundation

struct TitleDescriptionViewModel {
    let titleData: DetailedTitleData

    var title: String? {
        return String(htmlEncodedString: titleData.title)
    }

    var description: String? {
        return String(htmlEncodedString: titleData.description)
    }

    var coverUrl: URL {
        return titleData.coverUrl
    }

    var largeCoverUrl: URL? {
        return titleData.largeCoverUrl
    }

    var id: String? {
        if let id = titleData.id {
            return String(id)
        }
        return nil
    }
}

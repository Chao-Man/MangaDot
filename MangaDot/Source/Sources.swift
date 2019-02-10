//
//  Source.swift
//  MangaDot
//
//  Created by Jian Chao Man on 4/1/19.
//  Copyright © 2019 Jian Chao Man. All rights reserved.
//

import Foundation
import PromiseKit

protocol SourceProtocol {
    func fetchFeed() -> Promise<FeedProtocol>
    func fetchTitleInfo(id: Int) -> Promise<TitleInfoProtocol>
}

extension SourceProtocol {
    func typeName() -> String {
        return String(describing: type(of: self))
    }
}

class Sources {
    let userDefaultKey = "userDefault"
    
    func setDefault(source: SourceProtocol) {
        UserDefaults.standard.set(source.typeName(), forKey: userDefaultKey)
    }

    func getDefault() -> SourceProtocol {
        let key = UserDefaults.standard.string(forKey: userDefaultKey)
        return resolveSource(withKey: key)
    }

    func resolveSource(withKey key: String?) -> SourceProtocol {
        switch key {
        case "Mangadex":
            return mangadex
        default:
            return mangadex
        }
    }
    
    struct Sorting {
        enum OrderBy {
            case ascending
            case descending
        }
        enum Attribute {
            case title
            case recent
            case chapter
            case volume
            case volumeAndChapter
        }
    }

    // Manga sources
    public lazy var mangadex = Mangadex()
}

//
//  LibraryViewModel.swift
//  MangaDot
//
//  Created by Jian Chao Man on 13/3/19.
//  Copyright © 2019 Jian Chao Man. All rights reserved.
//

import Foundation
import PromiseKit
import Realm
import RealmSwift

public final class LibraryViewModel {
    // MARK: - Private Instance Properties
    
    private let sources = [
        Current.sources.mangadex
    ]
    
    // MARK: - Object Lifecycle
    
//    init() {
//
//    }
    
    // MARK: - Methods
    
    
    
    public func numberOfSections() -> Int {
        return sources.count
    }
    
//    public func sections() -> [SectionProtocol] {
//
//    }
    
    // MARK: - Helper Methods
    
//    private func section(source: SourceProtocol) -> SectionProtocol {
//
//        source.name()
//    }
    
    func titleInfo(sourceName: String) -> Results<TitleInfoPersist> {
        let predicate = NSPredicate(format: "source = %@", sourceName)
        return Current
            .realm
            .objects(TitleInfoPersist.self)
            .filter(predicate)
    }
}

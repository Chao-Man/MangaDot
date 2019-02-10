//
//  FeedViewModel.swift
//  MangaDot
//
//  Created by Jian Chao Man on 4/1/19.
//  Copyright © 2019 Jian Chao Man. All rights reserved.
//

import Foundation
import PromiseKit

public final class FeedViewModel {
    // MARK: - Private Instance Properties

    private let source: SourceProtocol
    private var feed: FeedProtocol?

    // MARK: - Object Lifecycle

    init(_ source: SourceProtocol) {
        self.source = source
    }

    // MARK: - Methods

    public func fetchFeed() -> Promise<Void> {
        return firstly {
            source.fetchFeed()
        }.done { [weak self] feed in
            self?.feed = feed
        }
    }

    public func numberOfSections() -> Int {
        guard let feed = self.feed else { return 0 }
        return feed.sections.count
    }

    public func sections() -> [SectionProtocol] {
        guard let feed = self.feed else { return [] }
        return feed.sections
    }

    // MARK: - Helper Methods
}

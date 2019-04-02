//
//  TitleInfoViewModel.swift
//  MangaDot
//
//  Created by Jian Chao Man on 14/1/19.
//  Copyright © 2019 Jian Chao Man. All rights reserved.
//

import UIKit
import Nuke
import PromiseKit
import Realm
import RealmSwift

final class TitleInfoViewModel {
    // MARK: - Types

    enum Errors: Error {
        case titleInfoDoesNotExist
        case coverDoesNotExist
    }

    // MARK: - Private Instance Properties

    private let id: Int
    private let pipeline = Current.nukeConfig.titleInfoImagePipeline
    private var titleInfo: TitleInfoProtocol? {
        didSet {
            sortedChapters = nil
        }
    }
    let source: SourceProtocol
    var sortedChapters: [BasicChapterProtocol]?
    
    // MARK: - Computed Instance Properties
    
    // MARK: - Instance Properties
    
    var sortBy = Sources.Sorting.Attribute.volumeAndChapter {
        didSet {
            sortedChapters = nil
        }
    }
    
    var orderBy = Sources.Sorting.OrderBy.descending {
        didSet {
            sortedChapters = nil
        }
    }
    
    var langCode = "gb" {
        didSet {
            sortedChapters = nil
        }
    }
    
    // MARK: - Life Cycle

    init(id: Int, source: SourceProtocol) {
        self.id = id
        self.source = source
    }

    // MARK: - Methods

    @discardableResult public func fetch() -> Promise<Void> {
        return firstly {
            source.fetchTitleInfo(id: id)
        }.done { [weak self] titleInfo in
            self?.titleInfo = titleInfo
        }
    }

    func fetchLargeCover(imageView: UIImageView, placeholderImage: UIImage?) throws -> Promise<ImageResponse> {
        guard let titleInfo = titleInfo else { throw Errors.titleInfoDoesNotExist }
        guard let coverUrl = titleInfo.largeCoverUrl else { throw Errors.coverDoesNotExist }
        let options = ImageLoadingOptions(placeholder: placeholderImage, transition: nil, failureImage: placeholderImage, failureImageTransition: .none, contentModes: nil)
        let fetch = Current.nukeWrapper.fetchImage(imageView: imageView, url: coverUrl, options: options)
        return fetch
    }

    func title() -> String {
        guard let titleInfo = titleInfo else { return "" }
        return titleInfo.title
    }

    func description() -> String {
        guard let titleInfo = titleInfo else { return "" }
        return titleInfo.description
    }

    func author() -> [String] {
        guard let titleInfo = titleInfo else { return [] }
        return titleInfo.author.split(separator: ",").map { String($0) }
    }

    func artist() -> [String] {
        guard let titleInfo = titleInfo else { return [] }
        return titleInfo.artist.split(separator: ",").map { String($0) }
    }

    func genre() -> [String] {
        guard let titleInfo = titleInfo else { return [] }
        return titleInfo.genres.map { Mangadex.Genre.toString(id: $0) }
    }
    
    func numberOfChapters() -> Int {
        return getSortedChapters().count
    }

    func chapter(index: Int) -> BasicChapterProtocol? {
        if !chapterIndexIsInRange(index: index) { return nil }
        return getSortedChapters()[index]
    }
    
    // Realm related functions
    
    func existsInLibrary() -> Bool {
        guard let titleInfo = titleInfo else { return false }
        return Current.realm.object(ofType: TitleInfoPersist.self, forPrimaryKey: titleInfo.id) != nil
    }
    
    func addToLibrary() {
        guard let titleInfo = titleInfo else { return }
        guard let titleInfoPersist = titleInfo.persist(source: source.name()) else { return }
        try! Current.realm.write {
            Current.realm.add(titleInfoPersist)
        }
    }
    
    func removeFromLibrary() {
        guard let titleInfo = titleInfo else { return }
        guard let titleInfoPersist = Current.realm.object(ofType: TitleInfoPersist.self, forPrimaryKey: titleInfo.id) else { return }
        try! Current.realm.write {
            Current.realm.delete(titleInfoPersist)
        }
    }
    
    // MARK: - Private Helper Methods
    
    private func getSortedChapters() -> [BasicChapterProtocol] {
        // Already sorted
        if let sortedChapters = self.sortedChapters {
            return sortedChapters
        }
        // Haven't fetched chapter data
        guard let titleInfo = self.titleInfo else {
            sortedChapters = []
            return sortedChapters!
        }
        // Sort & filter chapters
        sortedChapters = titleInfo.chapters(sortUsing: sortBy, orderBy: orderBy, langCode: langCode)
        return sortedChapters!
    }
    
    private func chapterIndexIsInRange(index: Int) -> Bool {
        return (index >= 0 && index < numberOfChapters())
    }
}

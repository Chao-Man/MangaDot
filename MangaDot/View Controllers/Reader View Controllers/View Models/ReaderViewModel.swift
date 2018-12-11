//
//  ReaderViewModel.swift
//  MangaDot
//
//  Created by Jian Chao Man on 4/11/18.
//  Copyright © 2018 Jian Chao Man. All rights reserved.
//

import Foundation
import Kingfisher

class ReaderViewModel {
    // MARK: - Types

    enum ChapterPageDataError: Error {
        case noChapterPageDataAvailable
        case chapterIdDoesNotExist
    }

    // MARK: - Type Aliases

    typealias DidFetchChapterPagesDataCompletion = (ChapterPageData?, ChapterPageDataError?) -> Void
    typealias DidReloadChapterPagesDataCompletion = (ChapterPageDataError?) -> Void
    typealias DidUpdateChapterPagesDataCompletion = (ChapterPageDataError?) -> Void

    // MARK: - Properties

    private var currentChapterId: Int
    private let chapterIds: [Int]

    var currentChapter: ChapterPageData?
    private var nextChapter: ChapterPageData?
    private var previousChapter: ChapterPageData?
    private var prefetcher: ImagePrefetcher?
    private var prefetchArray: [URL?] = [] {
        didSet {
            if prefetchArray.count > 0 {
                prefetch(pageUrls: prefetchArray)
            }
        }
    }

    private var didFetchChapterPageData: DidFetchChapterPagesDataCompletion?
    var didReloadChapterPages: DidReloadChapterPagesDataCompletion?
    var didUpdateChapterPages: DidUpdateChapterPagesDataCompletion?

    // MARK: - Methods

    init(selectedChapterId: Int, chapterIds: [Int]) throws {
        currentChapterId = selectedChapterId
        self.chapterIds = chapterIds
    }

    deinit {
        prefetcher?.stop()
    }

    func getChapter(withPageUrl pageUrl: URL) -> ChapterPageData? {
        if let nextChapter = nextChapter {
            if nextChapter.pageUrlArray.contains(pageUrl) {
                return nextChapter
            }
        }
        if let previousChapter = previousChapter {
            if previousChapter.pageUrlArray.contains(pageUrl) {
                return previousChapter
            }
        }
        return currentChapter
    }

    func reload() {
        let completion: DidFetchChapterPagesDataCompletion = { [weak self] data, error in
            if let _ = error {
                self?.didReloadChapterPages?(error)
            }

            if let data = data {
                self?.currentChapter = data
                self?.prefetchArray += data.pageUrlArray
            }
            self?.didReloadChapterPages?(nil)

            self?.fetchNextChapterPages()
            self?.fetchPrevChapterPages()
        }

        fetchMangadexPagesData(chapterId: currentChapterId, didFetchChapterPageData: completion)
    }

    func firstPageUrl() -> URL? {
        guard let pageUrl = currentChapter?.pageUrlArray.first else { return nil }
        return pageUrl
    }

    func nextPageUrl(currentPageUrl: URL) -> URL? {
        guard let index = pageIndex(pageUrl: currentPageUrl) else { return nil }

        if isLastPage(index: index) {
            guard let nextChapterPage = nextChapter?.pageUrlArray.first else { return nil }
            return nextChapterPage
        }

        return currentChapter?.pageUrlArray[index + 1]
    }

    func prevPageUrl(currentPageUrl: URL) -> URL? {
        guard let index = pageIndex(pageUrl: currentPageUrl) else { return nil }

        if isFirstPage(index: index) {
            guard let prevChapterPage = previousChapter?.pageUrlArray.last else { return nil }
            return prevChapterPage
        }

        return currentChapter?.pageUrlArray[index - 1]
    }

    private func fetchMangadexPagesData(chapterId: Int, didFetchChapterPageData: @escaping DidFetchChapterPagesDataCompletion) {
        let pagesRequest = MangadexApiRequest(baseUrl: MangadexService.baseApiUrl, type: .chapter, id: String(chapterId))
        var request = URLRequest(url: pagesRequest.url)
        request.setValue("Accept-Encoding", forHTTPHeaderField: "compress, gzip")

        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let response = response as? HTTPURLResponse {
                print("Status Code: \(response.statusCode)")
            }

            DispatchQueue.main.async {
                if let error = error {
                    print("Unable to Fetch Manga Data \(error)")

                    self?.didFetchChapterPageData?(nil, .noChapterPageDataAvailable)
                } else if let data = data {
                    // Initilise JSON Decoder
                    let decoder = JSONDecoder()

                    // Configure JSON Decoder
                    decoder.dateDecodingStrategy = .secondsSince1970
                    decoder.keyDecodingStrategy = .convertFromSnakeCase

                    do {
                        // Decode Response
                        let mangadexChapterResponse = try decoder.decode(MangadexChapterResponse.self, from: data)

                        didFetchChapterPageData(mangadexChapterResponse, nil)
                    } catch {
                        print("Unable to Decode Mangadex Response \(error)")

                        // Invoke Completion Handler
                        self?.didFetchChapterPageData?(nil, .noChapterPageDataAvailable)
                    }
                } else {
                    self?.didFetchChapterPageData?(nil, .noChapterPageDataAvailable)
                }
            }
        }.resume()
    }

    // MARK: - Helper Methods

    private func prefetch(pageUrls: [URL?]) {
        let uncachedPageUrls = pageUrls.compactMap { (pageUrl) -> URL? in
            guard let pageUrlString = pageUrl?.absoluteString else { return nil }
            guard ImageCache.default.imageCachedType(forKey: pageUrlString) == .none else { return nil }
            return pageUrl
        }
        let prefetcherCompletion: PrefetcherCompletionHandler = { [weak self] _, _, _ in ()
            self?.prefetchArray = []
        }
        if let currentPrefetcher = prefetcher {
            currentPrefetcher.stop()
        }
        prefetcher = ImagePrefetcher(urls: uncachedPageUrls, completionHandler: prefetcherCompletion)
        prefetcher?.maxConcurrentDownloads = 3
        prefetcher?.start()
    }

    private func pageIndex(pageUrl: URL) -> Int? {
        var index: Int?
        if let i = currentChapter?.pageUrlArray.index(of: pageUrl) {
            index = i
        } else if let i = nextChapter?.pageUrlArray.index(of: pageUrl) {
            index = i
            guard let nextChapterId = nextChapterId(chapter: currentChapterId) else {
                return nil
            }
            previousChapter = currentChapter
            currentChapter = nextChapter
            nextChapter = nil
            currentChapterId = nextChapterId
            fetchNextChapterPages()
        } else if let i = previousChapter?.pageUrlArray.index(of: pageUrl) {
            index = i
            guard let prevChapterId = prevChapterId(chapter: currentChapterId) else {
                return nil
            }
            nextChapter = currentChapter
            currentChapter = previousChapter
            previousChapter = nil
            currentChapterId = prevChapterId
            fetchPrevChapterPages()
        } else {
            return nil
        }

        return index
    }

    private func isLastPage(index: Int) -> Bool {
        guard let currentPageCount = currentChapter?.pageUrlArray.count else { return false }
        return index == (currentPageCount - 1)
    }

    private func isFirstPage(index: Int) -> Bool {
        return index == 0
    }

    private func getChapterId(with index: Int) -> Int? {
        guard index < chapterIds.count && index >= 0 else {
            print("Chapter index \(index) is not in range")
            return nil
        }
        return chapterIds[index]
    }

    private func nextChapterId(chapter: Int) -> Int? {
        guard let chapterIndex = chapterIds.index(of: chapter) else {
            print("Can't find chapter id in chapter id array")
            return nil
        }
        let nextChapterIndex = chapterIndex + 1
        return getChapterId(with: nextChapterIndex)
    }

    private func prevChapterId(chapter: Int) -> Int? {
        guard let chapterIndex = chapterIds.index(of: chapter) else {
            print("Can't find chapter id in chapter id array")
            return nil
        }
        let previousChapterIndex = chapterIndex - 1
        return getChapterId(with: previousChapterIndex)
    }

    private func fetchNextChapterPages() {
        guard let nextChapterId = nextChapterId(chapter: currentChapterId) else { return }

        let completion: DidFetchChapterPagesDataCompletion = { [weak self] data, error in
            if let _ = error {
                self?.didUpdateChapterPages?(error)
            }

            if let data = data {
                self?.nextChapter = data
                self?.prefetchArray += data.pageUrlArray
            }
            self?.didUpdateChapterPages?(nil)
        }

        fetchMangadexPagesData(chapterId: nextChapterId, didFetchChapterPageData: completion)
    }

    private func fetchPrevChapterPages() {
        guard let prevChapterId = prevChapterId(chapter: currentChapterId) else { return }

        let completion: DidFetchChapterPagesDataCompletion = { [weak self] data, error in
            if let _ = error {
                self?.didUpdateChapterPages?(error)
            }

            if let data = data {
                self?.previousChapter = data
            }
            self?.didUpdateChapterPages?(nil)
        }

        fetchMangadexPagesData(chapterId: prevChapterId, didFetchChapterPageData: completion)
    }
}

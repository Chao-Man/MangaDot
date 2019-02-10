//
//  CarouselViewModel.swift
//  MangaDot
//
//  Created by Jian Chao Man on 7/1/19.
//  Copyright © 2019 Jian Chao Man. All rights reserved.
//

import Nuke
import PromiseKit
import UIKit

class CarouselViewModel {
    // MARK: - Instance Properties

    private var data: SectionProtocol
    private var smallCoverTasks: [Int: CancelClosure] = [:]
    private var largeCoverTasks: [Int: CancelClosure] = [:]
    private let largeImagePipeline = Current.nukeConfig.feedLargeImagePipeline
    private let smallImagePipeline = Current.nukeConfig.feedSmallImagePipeline

    // MARK: - Computed Instance Properties

    // MARK: - Types

    enum Errors: Error {
        case indexOutOfRange
        case urlDoesNotExist
    }

    // MARK: - Life Cycle

    init(_ data: SectionProtocol) {
        self.data = data
    }

    // MARK: - Methods

    func sectionName() -> String {
        return data.sectionName
    }

    func numberOfManga() -> Int {
        return data.titleList.count
    }

    func manga(withIndex index: Int) throws -> BasicTitleProtocol {
        if indexOutOfRange(index) {
            throw Errors.indexOutOfRange
        }
        return data.titleList[index]
    }

    func mangaId(withIndex index: Int) -> Int? {
        if indexOutOfRange(index) { return nil }
        return data.titleList[index].titleId
    }

    func mangaTitle(withIndex index: Int) -> String? {
        if indexOutOfRange(index) { return nil }
        return data.titleList[index].title
    }

    func mangaCoverUrl(withIndex index: Int) -> URL? {
        if indexOutOfRange(index) { return nil }
        return data.titleList[index].coverUrl
    }

    func mangaLargeCoverUrl(withIndex index: Int) -> URL? {
        if indexOutOfRange(index) { return nil }
        return data.titleList[index].largeCoverUrl
    }

    func isImageLargeCoverCached(index: Int) -> Bool {
        guard let url = mangaLargeCoverUrl(withIndex: index) else { return false }
        let request = ImageRequest(url: url)
        return largeImagePipeline.configuration.imageCache?.cachedResponse(for: request) != nil
    }

    func fetchSmallCover(withIndex index: Int, size: CGSize) -> Promise<ImageResponse> {
        guard let url = mangaCoverUrl(withIndex: index) else {
            return rejectedFetchPromise()
        }

        let request = Current.downloadClient.imageRequestBuilder(url, targetSize: size)
        let fetch = Current.downloadClient.fetchImage(request: request, imagePipeline: smallImagePipeline)
        let promise = fetch.promise
        smallCoverTasks[index] = fetch.cancel
        return promise
    }

    func fetchLargeCover(withIndex index: Int, size: CGSize) -> Promise<ImageResponse> {
        guard let url = mangaLargeCoverUrl(withIndex: index) else {
            return rejectedFetchPromise()
        }

        let request = Current.downloadClient.imageRequestBuilder(url, targetSize: size)
        let fetch = Current.downloadClient.fetchImage(request: request, imagePipeline: largeImagePipeline)
        let promise = fetch.promise
        largeCoverTasks[index] = fetch.cancel
        return promise
    }
    
    func fetchLargeCover(withIndex index: Int) -> Promise<ImageResponse> {
        guard let url = mangaLargeCoverUrl(withIndex: index) else {
            return rejectedFetchPromise()
        }
        
        let request = Current.downloadClient.imageRequestBuilder(url)
        let fetch = Current.downloadClient.fetchImage(request: request, imagePipeline: largeImagePipeline)
        let promise = fetch.0
        largeCoverTasks[index] = fetch.1
        return promise
    }

    func cancelDownloadTask(atIndex index: Int) {
        if let cancel = largeCoverTasks[index] {
            cancel()
        }
        if let cancel = smallCoverTasks[index] {
            cancel()
        }
        largeCoverTasks.removeValue(forKey: index)
        smallCoverTasks.removeValue(forKey: index)
    }

    func cancelAllTasks() {
        largeCoverTasks.forEach {
            $0.value()
        }
        smallCoverTasks.forEach {
            $0.value()
        }
        largeCoverTasks = [:]
        smallCoverTasks = [:]
    }

    // MARK: - Private Helper Methods

    private func indexOutOfRange(_ index: Int) -> Bool {
        return index < 0 || index > (numberOfManga() - 1)
    }

    private func rejectedFetchPromise() -> Promise<ImageResponse> {
        let promise = Promise<ImageResponse> { $0.reject(Errors.urlDoesNotExist) }
        return promise
    }

    private func rejectedCancellablePromise() -> CancellablePromise {
        let promise = rejectedFetchPromise()
        let cancel: CancelClosure = {}
        return (promise, cancel)
    }
}

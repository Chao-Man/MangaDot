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
        let cache = DataLoader.sharedUrlCache.cachedResponse(for: request.urlRequest)
        return cache != nil
    }

    func fetchSmallCover(withIndex index: Int, imageView: UIImageView) -> Promise<ImageResponse> {
        guard let url = mangaCoverUrl(withIndex: index) else {
            return rejectedFetchPromise()
        }
        let targetSize = CGSize(width: imageView.bounds.width * UIScreen.main.scale, height: imageView.bounds.height * UIScreen.main.scale)
        let request = ImageRequest(url: url, targetSize: targetSize, contentMode: .aspectFit)
        return Current.nukeWrapper.fetchImage(imageView: imageView, request: request, options: nil)
    }
    
    func fetchLargeCover(withIndex index: Int, imageView: UIImageView) -> Promise<ImageResponse> {
        guard let url = mangaLargeCoverUrl(withIndex: index) else {
            return rejectedFetchPromise()
        }
        return Current.nukeWrapper.fetchImage(imageView: imageView, url: url, options: nil)
    }

    func fetchLargeCover(withIndex index: Int, imageView: UIImageView, placeholderImage: UIImage) -> Promise<ImageResponse> {
        guard let url = mangaLargeCoverUrl(withIndex: index) else {
            return rejectedFetchPromise()
        }
        let options = ImageLoadingOptions(placeholder: placeholderImage, transition: nil, failureImage: placeholderImage, failureImageTransition: nil, contentModes: nil)
        let targetSize = CGSize(width: imageView.bounds.width * UIScreen.main.scale, height: imageView.bounds.height * UIScreen.main.scale)
        let request = ImageRequest(url: url, targetSize: targetSize, contentMode: .aspectFit)
        return Current.nukeWrapper.fetchImage(imageView: imageView, request: request, options: options)
    }

    // MARK: - Private Helper Methods

    private func indexOutOfRange(_ index: Int) -> Bool {
        return index < 0 || index > (numberOfManga() - 1)
    }

    private func rejectedFetchPromise() -> Promise<ImageResponse> {
        let promise = Promise<ImageResponse> { $0.reject(Errors.urlDoesNotExist) }
        return promise
    }
}

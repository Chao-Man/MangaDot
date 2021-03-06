//
//  NukeWrapper.swift
//  MangaDot
//
//  Created by Jian Chao Man on 24/1/19.
//  Copyright © 2019 Jian Chao Man. All rights reserved.
//

import Nuke
import PromiseKit
import UIKit

typealias CancelClosure = () -> Void
typealias CancellablePromise = (promise: Promise<ImageResponse>, cancel: CancelClosure)

struct NukeWrapper {
//    enum Errors: Error {
//        case cancelled
//    }
//
//    func fetchImage(request: ImageRequest) -> CancellablePromise {
//        var cancel: CancelClosure = {}
//        let promise = Promise<ImageResponse> { seal in
//            let task = ImagePipeline.shared.loadImage(with: request, completion: { imageResponse, error in
//                seal.resolve(error, imageResponse)
//            })
//            cancel = {
//                seal.reject(Errors.cancelled)
//                task.cancel()
//            }
//        }
//        return (promise, cancel)
//    }
//
//    func fetchImage(request: ImageRequest, imagePipeline: ImagePipeline) -> CancellablePromise {
//        var cancel: CancelClosure = {}
//        let promise = Promise<ImageResponse> { seal in
//            let task = imagePipeline.loadImage(with: request, completion: { imageResponse, error in
//                seal.resolve(error, imageResponse)
//            })
//            cancel = {
//                task.cancel()
//                seal.reject(Errors.cancelled)
//            }
//        }
//        return (promise, cancel)
//    }
//
    func imageRequestBuilder(_ url: URL, targetSize: CGSize) -> ImageRequest {
        return ImageRequest(url: url, targetSize: targetSize, contentMode: .aspectFit, upscale: true)
    }

    func imageRequestBuilder(_ url: URL) -> ImageRequest {
        return ImageRequest(url: url)
    }
    
    func fetchImage(imageView: UIImageView, request: ImageRequest, options: ImageLoadingOptions?) -> Promise<ImageResponse> {
        let imageOptions = options ?? ImageLoadingOptions(placeholder: nil, transition: nil, failureImage: nil, failureImageTransition: nil, contentModes: nil)
        return Promise<ImageResponse> { seal in
            Nuke.loadImage(with: request, options: imageOptions, into: imageView, progress: nil, completion: { (imageResponse, error) in
                seal.resolve(imageResponse, error)
            })
        }
    }
    
    func fetchImage(imageView: UIImageView, url: URL, options: ImageLoadingOptions?) -> Promise<ImageResponse> {
        let imageOptions = options ?? ImageLoadingOptions(placeholder: nil, transition: nil, failureImage: nil, failureImageTransition: nil, contentModes: nil)
        return Promise<ImageResponse> { seal in
            Nuke.loadImage(with: url, options: imageOptions, into: imageView, progress: nil, completion: { (imageResponse, error) in
                seal.resolve(imageResponse, error)
            })
        }
    }

}


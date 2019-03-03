//
//  NukeConfig.swift
//  MangaDot
//
//  Created by Jian Chao Man on 9/1/19.
//  Copyright © 2019 Jian Chao Man. All rights reserved.
//

import Foundation
import Nuke

struct NukeConfig {
    lazy var feedSmallImagePipeline: ImagePipeline = {
        let pipeline = ImagePipeline {
            // Shared image cache with a `sizeLimit` equal to ~20% of available RAM.
            $0.imageCache = ImageCache.shared
            $0.dataLoader = DataLoader()
            
            // Custom disk cache is disabled by default, the native URL cache used
            // by a `DataLoader` is used instead.
            $0.dataCache = nil
            
            // Each stage is executed on a dedicated queue with has its own limits.
            $0.dataLoadingQueue.maxConcurrentOperationCount = 3
            $0.imageDecodingQueue.maxConcurrentOperationCount = 2
            $0.imageProcessingQueue.maxConcurrentOperationCount = 2
            
            // Combine the requests for the same original image into one.
            $0.isDeduplicationEnabled = true
            
            // Progressive decoding is a resource intensive feature so it is
            // disabled by default.
            $0.isProgressiveDecodingEnabled = false
        }
        
        return pipeline
    }()
    
    lazy var feedLargeImagePipeline: ImagePipeline = {
        let pipeline = ImagePipeline {
            // Shared image cache with a `sizeLimit` equal to ~20% of available RAM.
            $0.imageCache = ImageCache.shared
            $0.dataLoader = DataLoader()
            
            // Custom disk cache is disabled by default, the native URL cache used
            // by a `DataLoader` is used instead.
            $0.dataCache = nil
            
            // Each stage is executed on a dedicated queue with has its own limits.
            $0.dataLoadingQueue.maxConcurrentOperationCount = 3
            $0.imageDecodingQueue.maxConcurrentOperationCount = 2
            $0.imageProcessingQueue.maxConcurrentOperationCount = 2
            
            // Combine the requests for the same original image into one.
            $0.isDeduplicationEnabled = true
            
            // Progressive decoding is a resource intensive feature so it is
            // disabled by default.
            $0.isProgressiveDecodingEnabled = false
        }
        
        return pipeline
    }()
    
    lazy var titleInfoImagePipeline: ImagePipeline = {
        let pipeline = ImagePipeline {
            // Shared image cache with a `sizeLimit` equal to ~20% of available RAM.
            $0.imageCache = ImageCache.shared
            $0.dataLoader = DataLoader()
            
            // Custom disk cache is disabled by default, the native URL cache used
            // by a `DataLoader` is used instead.
            $0.dataCache = nil
            
            // Each stage is executed on a dedicated queue with has its own limits.
            $0.dataLoadingQueue.maxConcurrentOperationCount = 1
            $0.imageDecodingQueue.maxConcurrentOperationCount = 1
            $0.imageProcessingQueue.maxConcurrentOperationCount = 1
            
            // Combine the requests for the same original image into one.
            $0.isDeduplicationEnabled = false
            
            // Progressive decoding is a resource intensive feature so it is
            // disabled by default.
            $0.isProgressiveDecodingEnabled = false
        }
        
        return pipeline
    }()
    
    lazy var readerImagePipelne: ImagePipeline = {
        let pipeline = ImagePipeline {
            // Shared image cache with a `sizeLimit` equal to ~20% of available RAM.
            $0.imageCache = ImageCache.shared
            $0.dataLoader = DataLoader()
            
            // Custom disk cache is disabled by default, the native URL cache used
            // by a `DataLoader` is used instead.
            $0.dataCache = nil
            
            // Each stage is executed on a dedicated queue with has its own limits.
            $0.dataLoadingQueue.maxConcurrentOperationCount = 3
            $0.imageDecodingQueue.maxConcurrentOperationCount = 3
            $0.imageProcessingQueue.maxConcurrentOperationCount = 3
            
            // Combine the requests for the same original image into one.
            $0.isDeduplicationEnabled = true
            
            // Progressive decoding is a resource intensive feature so it is
            // disabled by default.
            $0.isProgressiveDecodingEnabled = false
        }
        
        return pipeline
    }()
    
    init() {
        // Configure Memory cache
        ImageCache.shared.costLimit = 1024 * 1024 * 100 // 100 MB
        ImageCache.shared.countLimit = 1000
        DataLoader.sharedUrlCache.diskCapacity = 1024 * 1024 * 500 // 500 MB
        DataLoader.sharedUrlCache.memoryCapacity = 1024 * 1024 * 200 // 100 MB
        ImageLoadingOptions.shared.alwaysTransition = true
        ImageLoadingOptions.shared.transition = ImageLoadingOptions.Transition.fadeIn(duration: 0.33)
        ImageLoadingOptions.shared.isPrepareForReuseEnabled = false
    }
}

//
//  MangadexRequest.swift
//  Manga
//
//  Created by Jian Chao Man on 27/9/18.
//  Copyright © 2018 Jian Chao Man. All rights reserved.
//

import Foundation

struct MangadexApiRequest {
    
    // MARK: - Properties
    
    let baseUrl: URL
    let type: MangadexService.ApiType
    let id: String
    
    // MARK: -
    
    var url: URL {
        return URL(string: "\(baseUrl.absoluteString)?id=\(id)&type=\(type.rawValue)")!
    }
}

struct MangadexFeedRequest {
    // MARK: - Propeties
    
    let baseUrl: URL
    
    // MARK: -
    
    var url: URL {
        return baseUrl
    }
}

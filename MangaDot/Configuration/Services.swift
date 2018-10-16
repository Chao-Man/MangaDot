//
//  Services.swift
//  Manga
//
//  Created by Jian Chao Man on 27/9/18.
//  Copyright © 2018 Jian Chao Man. All rights reserved.
//

import Foundation

enum MangadexService {
    // TODO: - Don't store API as plain text string
    
    static let apiKey = "xTfEPeSg73sa2nuWHQ9t5Ubcp84dCDV6"
    static let baseUrl = URL(string: "https://mangadex.org")!
    static let baseApiUrl = baseUrl.appendingPathComponent("api")
    static let baseRssUrl = baseUrl.appendingPathComponent("rss")
    static let authenticatedRssUrl = baseApiUrl.appendingPathComponent(apiKey)
    
    enum ApiType: String {
        case title = "manga"
        case chapter = "chapter"
    }
}

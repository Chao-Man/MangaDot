//
//  MangadexChapterResponse.swift
//  MangaDot
//
//  Created by Jian Chao Man on 29/9/18.
//  Copyright © 2018 Jian Chao Man. All rights reserved.
//

import Foundation

struct MangadexChapterResponse: Codable {
    let id: Int
    let timestamp: Date
    let hash: String
    let volume: String
    let chapter: String
    let title: String
    let langName: String
    let langCode: String
    let mangaId: Int
    let groupId: Int
    let groupId2: Int
    let groupId3: Int
    let comments: Int?
    let server: URL
    let pageArray: [String]
    let longStrip: Int8
    let status: String
}

extension MangadexChapterResponse: ChapterPageData {
    var pageUrlArray: [URL?] {
        return pageArray.map { (page) -> URL? in
            URL(string: "\(server)")?.appendingPathComponent(hash).appendingPathComponent(page)
        }
    }
}

//
//  DetailedChapterProtocol.swift
//  MangaDot
//
//  Created by Jian Chao Man on 14/2/19.
//  Copyright © 2019 Jian Chao Man. All rights reserved.
//

import Foundation

protocol DetailedChapterProtocol {
    var id: Int { get }
    var timestamp: Date { get }
    var hash: String { get }
    var langName: String { get }
    var mangaId: Int { get }
    var comments: Int? { get }
    var server: URL { get }
    var pageUrlArray: [URL] { get }
    var longStrip: Int8 { get }
    var status: String { get }
    var volume: String { get }
    var chapter: String { get }
    var title: String { get }
    var langCode: String { get }
    var groupId: Int { get }
    var groupId2: Int { get }
    var groupId3: Int { get }
}

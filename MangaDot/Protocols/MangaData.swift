//
//  TitleData.swift
//  Manga
//
//  Created by Jian Chao Man on 25/9/18.
//  Copyright © 2018 Jian Chao Man. All rights reserved.
//

import Foundation

protocol FeedData {
    var sections: [SectionData]      { get }
}

protocol SectionData {
    var sectionName: String          { get }
    var titleList: [TitleData]       { get }
}

protocol TitleData {
    var id: Int?                     { get }
    var coverUrl: URL                { get }
    var largeCoverUrl: URL?          { get }
    var title: String                { get }
}

protocol ChapterData {
    var volume: String               { get }
    var chapter: String              { get }
    var title: String                { get }
    var langCode: String             { get }
    var groupId: Int                 { get }
    var groupId2: Int                { get }
    var groupId3: Int                { get }
}

protocol DetailedTitleData: TitleData {
    func chapters(withLanguage langCode: String, orderBy: OrderBy) -> [TitleChapterData]
    
    var description: String          { get }
    var artist: String               { get }
    var author: String               { get }
    var status: Int8                 { get }
    var genres: [Int8]               { get }
    var lastChapter: String          { get }
    var langName: String             { get }
    var langFlag: String             { get }
    var chapters: [TitleChapterData] { get }
}

protocol TitleChapterData: ChapterData {
    var id: Int                      { get }
    var groupName: String?           { get }
    var groupName2: String?          { get }
    var groupName3: String?          { get }
    var timestamp: Date              { get }
}

protocol DetailedChapterData: ChapterData {
    var id: Int                      { get }
    var timestamp: Date              { get }
    var hash: String                 { get }
    var langName: String             { get }
    var mangaId: String              { get }
    var comments: Int                { get }
    var server: URL                  { get }
    var pageUrlArray: [URL]          { get }
    var longStrip: Int8              { get }
    var status: String               { get }
}

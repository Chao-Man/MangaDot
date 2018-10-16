//
//  MangadexFeedResponse.swift
//  MangaDot
//
//  Created by Jian Chao Man on 29/9/18.
//  Copyright © 2018 Jian Chao Man. All rights reserved.
//

import Foundation
import SwiftSoup

enum MangadexFeedError: Error {
    case invalidDataFormat
}

struct MangadexFeedResponse: FeedData {
    
    // MARK: - Struct
    
    struct Section: SectionData {
        var sectionName: String
        var titleList: [TitleData]
    }
    
    class LatestItem: TitleData {
        let id: Int?
        let coverUrl: URL
        let largeCoverUrl: URL?
        let title: String
        
        init(el: Element) throws {
            let thumbnailPath = try el.select("img").attr("src")
            let coverPath = thumbnailPath.replacingOccurrences(of: ".thumb", with: ".large")
            let largeCoverPath = thumbnailPath.replacingOccurrences(of: ".thumb", with: "")
            let idString = largeCoverPath
                .replacingOccurrences(of: "/images/manga/", with: "")
                .replacingOccurrences(of: ".jpg", with: "")
            self.title = try el.select(".manga_title").attr("title")
            self.id = Int(idString)
            self.coverUrl = MangadexService.baseUrl.appendingPathComponent(coverPath)
            self.largeCoverUrl = MangadexService.baseUrl.appendingPathComponent(largeCoverPath)
        }
    }
    
    class FeaturedItem: TitleData {
        let id: Int?
        let coverUrl: URL
        let largeCoverUrl: URL?
        let title: String
        
        init(el: Element) throws {
            let thumbnailPath = try el.attr("data-src")
            let coverPath = thumbnailPath
            let largeCoverPath = thumbnailPath.replacingOccurrences(of: ".large", with: "")
            let idString = largeCoverPath
                .replacingOccurrences(of: "/images/manga/", with: "")
                .replacingOccurrences(of: ".jpg", with: "")
            self.title = try el.attr("title")
            self.id = Int(idString)
            self.coverUrl = MangadexService.baseUrl.appendingPathComponent(coverPath)
            self.largeCoverUrl = MangadexService.baseUrl.appendingPathComponent(largeCoverPath)
        }
    }
    
    class NewItem: TitleData {
        let id: Int?
        let coverUrl: URL
        let largeCoverUrl: URL?
        let title: String
        
        init(el: Element) throws {
            let thumbnailPath = try el.attr("data-src")
            let coverPath = thumbnailPath
            let largeCoverPath = thumbnailPath.replacingOccurrences(of: ".large", with: "")
            let idString = largeCoverPath
                .replacingOccurrences(of: "/images/manga/", with: "")
                .replacingOccurrences(of: ".jpg", with: "")
            self.title = try el.attr("title")
            self.id = Int(idString)
            self.coverUrl = MangadexService.baseUrl.appendingPathComponent(coverPath)
            self.largeCoverUrl = MangadexService.baseUrl.appendingPathComponent(largeCoverPath)
        }
    }
    
    struct Top {
        
        struct lastSixHours {
            
        }
        
        struct lastDay {
            
        }
        
        struct lastSevenDays {
            
        }
        
        struct AllTimeFollows {
            
        }
        
        struct AllTimeRating{
            
        }
    }
    
    // MARK: - Properties
    var sections: [SectionData] = []
    
    init(data: Data) throws {
        guard let dataString = String(data: data, encoding: String.Encoding.utf8) else {
            throw MangadexFeedError.invalidDataFormat
        }
        let doc = try SwiftSoup.parse(dataString)
        
        do {
            try setupLatestSection(doc: doc)
            try setupFeaturedSection(doc: doc)
            try setupNewSection(doc: doc)
        }
        catch {
            throw MangadexFeedError.invalidDataFormat
        }
    }
    
    // MARK: - Helper methods
    
    private mutating func setupLatestSection(doc: Document) throws {
        var titles: [TitleData] = []
        try doc.select("div.col-md-6").forEach({ (el) in
            titles.append(try LatestItem(el: el))
        })
        sections.append(Section(sectionName: "CarouselViewController.header.latest", titleList: titles))
    }
    
    private mutating func setupFeaturedSection(doc: Document) throws {
        var titles: [TitleData] = []
        try doc.select("div#hled_titles_owl_carousel>div>div.hover>a>img").forEach({ (el) in
            titles.append(try FeaturedItem(el: el))
        })
            
        sections.append(Section(sectionName: "CarouselViewController.header.featured", titleList: titles))
    }
    
    private mutating func setupNewSection(doc: Document) throws {
        var titles: [TitleData] = []
        try doc.select("div#new_titles_owl_carousel>div>div.hover>a>img").forEach({ (el) in
            titles.append(try NewItem(el: el))
        })
        sections.append(Section(sectionName: "CarouselViewController.header.new", titleList: titles))
    }
    
}

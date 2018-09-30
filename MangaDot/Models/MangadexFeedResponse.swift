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

class MangadexFeedResponse {
    
    // MARK: - Struct
    
    struct Latest: TitleData {
        let id: Int?
        let coverUrl: String
        let title: String
        
        init(el: Element) throws {
            let thumbUrl = try el.select("img").attr("src")
            coverUrl = thumbUrl.replacingOccurrences(of: ".thumb", with: "")
            title = try el.select("manga_title").attr("title")
            let idString = coverUrl
                .replacingOccurrences(of: "/images/manga/", with: "")
                .replacingOccurrences(of: ".jpg", with: "")
            id = Int(idString)
        }
    }
    
    struct Featured: TitleData {
        let id: Int?
        let coverUrl: String
        let title: String
        
        init(el: Element) throws {
            let thumbUrl = try el.attr("data-src")
            coverUrl = thumbUrl.replacingOccurrences(of: ".large", with: "")
            title = try el.attr("title")
            let idString = coverUrl
                .replacingOccurrences(of: "/images/manga/", with: "")
                .replacingOccurrences(of: ".jpg", with: "")
            id = Int(idString)
        }
    }
    
    struct New: TitleData {
        let id: Int?
        let coverUrl: String
        let title: String
        
        init(el: Element) throws {
            let thumbUrl = try el.attr("data-src")
            coverUrl = thumbUrl.replacingOccurrences(of: ".large", with: "")
            title = try el.attr("title")
            let idString = coverUrl
                .replacingOccurrences(of: "/images/manga/", with: "")
                .replacingOccurrences(of: ".jpg", with: "")
            id = Int(idString)
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
    
    private var latest: [Latest] = []
    private var featured: [Featured] = []
    private var new: [New] = []
    
    init(data: Data) throws {
        guard let dataString = String(data: data, encoding: String.Encoding.utf8) else {
            throw MangadexFeedError.invalidDataFormat
        }
        let doc = try SwiftSoup.parse(dataString)
        
        do {
            try setupLatestList(doc: doc)
            try setupFeaturedList(doc: doc)
        }
        catch {
            throw MangadexFeedError.invalidDataFormat
        }
    }
    
    // MARK: - Helper methods
    
    func setupLatestList(doc: Document) throws {
        try doc.select("div.col-md-6").forEach({ (el) in
            latest.append(try Latest(el: el))
        })
    }
    
    func setupFeaturedList(doc: Document) throws {
        try doc.select("div#hled_titles_owl_carousel>div>div.hover>a>img)").forEach({ (el) in
            featured.append(try Featured(el: el))
        })
    }
    
    func setupNewList(doc: Document) throws {
        try doc.select("div#new_titles_owl_carousel>div>div.hover>a>img").forEach({ (el) in
            new.append(try New(el: el))
        })
    }
    
}

//
//  Feed.swift
//  MangaDot
//
//  Created by Jian Chao Man on 3/1/19.
//  Copyright © 2019 Jian Chao Man. All rights reserved.
//

import Foundation
import SwiftSoup

extension Mangadex {
    class Feed: FeedProtocol {
        // MARK: - Properties

        public var sections: [SectionProtocol] = []

        // MARK: - Init

        init(data: Data) throws {
            guard let dataString = String(data: data, encoding: String.Encoding.utf8)
            else {
                throw Errors.invalidDataFormat
            }
            let document = try SwiftSoup.parse(dataString)
            // Sections
            sections.append(try NewSection(document))
            sections.append(try LatestSection(document))
            sections.append(try FeaturedSection(document))
            sections.append(try TopFollowsSection(document))
            sections.append(try TopRatedSection(document))
        }
    }
}

extension Mangadex.Feed {
    // MARK: - Parent/Section Definitions

    struct LatestSection: SectionProtocol {
        var sectionName = "Feed.Section.latest".localized()
        var titleList: [BasicTitleProtocol]

        init(_ document: Document) throws {
            titleList = try document.select("div.col-md-6").map { try MainPanelItem($0) }
        }
    }

    struct FeaturedSection: SectionProtocol {
        var sectionName = "Feed.Section.featured".localized()
        var titleList: [BasicTitleProtocol]

        init(_ document: Document) throws {
            titleList = try document.select("div#hled_titles_owl_carousel>div>div.hover>a").map { try CarouselItem($0) }
        }
    }

    struct NewSection: SectionProtocol {
        var sectionName = "Feed.Section.new".localized()
        var titleList: [BasicTitleProtocol]

        init(_ document: Document) throws {
            titleList = try document.select("div#new_titles_owl_carousel>div>div.hover>a").map { try CarouselItem($0) }
        }
    }

    struct TopFollowsSection: SectionProtocol {
        var sectionName = "Feed.Section.topFollows".localized()
        var titleList: [BasicTitleProtocol]

        init(_ document: Document) throws {
            titleList = try document.select("div#top_follows>ul>li.list-group-item").map { try SidePanelItem($0) }
        }
    }

    struct TopRatedSection: SectionProtocol {
        var sectionName = "Feed.Section.topRated".localized()
        var titleList: [BasicTitleProtocol]

        init(_ document: Document) throws {
            titleList = try document.select("div#top_rating>ul>li.list-group-item").map { try SidePanelItem($0) }
        }
    }
}

extension Mangadex.Feed {
    // MARK: - Nested Element/Item Definitions

    struct MainPanelItem: BasicTitleProtocol {
        var titleId: Int
        var coverUrl: URL
        var largeCoverUrl: URL?
        var title: String

        init(_ element: Element) throws {
            let thumbnailPath = try element.select("img").attr("src")
            let coverPath = thumbnailPath.replacingOccurrences(of: ".thumb", with: ".large")
            let largeCoverPath = thumbnailPath.replacingOccurrences(of: ".thumb", with: "")
            let hrefList = try element.select(".manga_title").attr("href").replacingOccurrences(of: "/title/", with: "").components(separatedBy: "/")
            
            guard let titleIdString = hrefList.first else {
                throw Mangadex.Errors.invalidTitleId
            }

            let _coverUrl = Mangadex.baseUrl.appendingPathComponent(coverPath)
            let _largeCoverUrl = Mangadex.baseUrl.appendingPathComponent(largeCoverPath)

            guard let _titleId = Int(titleIdString) else {
                throw Mangadex.Errors.invalidTitleId
            }

            title = try element.select(".manga_title").text()
            titleId = _titleId
            coverUrl = _coverUrl
            largeCoverUrl =  _largeCoverUrl
        }
    }

    struct CarouselItem: BasicTitleProtocol {
        var titleId: Int
        var coverUrl: URL
        var largeCoverUrl: URL?
        var title: String

        init(_ element: Element) throws {
            let coverPath = try element.select("img").attr("data-src")
            let largeCoverPath = coverPath.replacingOccurrences(of: ".large", with: "")

            let hrefList = try element.attr("href").replacingOccurrences(of: "/title/", with: "").components(separatedBy: "/")
            
            guard let titleIdString = hrefList.first else {
                throw Mangadex.Errors.invalidTitleId
            }
            
            let _coverUrl = Mangadex.baseUrl.appendingPathComponent(coverPath)
            let _largeCoverUrl = Mangadex.baseUrl.appendingPathComponent(largeCoverPath)
            
            guard let _titleId = Int(titleIdString) else {
                throw Mangadex.Errors.invalidTitleId
            }
            
            title = try element.select("img").attr("title")
            titleId = _titleId
            coverUrl = _coverUrl
            largeCoverUrl = _largeCoverUrl
        }
    }

    struct SidePanelItem: BasicTitleProtocol {
        var titleId: Int
        var coverUrl: URL
        var largeCoverUrl: URL?
        var title: String

        init(_ element: Element) throws {
            let thumbnailPath = try element.select("div.hover>a>img").attr("src")
            let coverPath = thumbnailPath.replacingOccurrences(of: ".thumb", with: ".large")
            let largeCoverPath = thumbnailPath.replacingOccurrences(of: ".thumb", with: "")
            
            let hrefList = try element.select("a").attr("href").replacingOccurrences(of: "/title/", with: "").components(separatedBy: "/")
            
            guard let titleIdString = hrefList.first else {
                throw Mangadex.Errors.invalidTitleId
            }
            
            let _coverUrl = Mangadex.baseUrl.appendingPathComponent(coverPath)
            let _largeCoverUrl = Mangadex.baseUrl.appendingPathComponent(largeCoverPath)
            
            guard let _titleId = Int(titleIdString) else {
                throw Mangadex.Errors.invalidTitleId
            }
            
            title = try element.select("p.border-bottom>a.manga_title").attr("title")
            titleId = _titleId
            coverUrl = _coverUrl
            largeCoverUrl = _largeCoverUrl
        }
    }
}

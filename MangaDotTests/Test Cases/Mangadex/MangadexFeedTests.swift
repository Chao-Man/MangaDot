//
//  MangadexFeedTests.swift
//  MangaDotTests
//
//  Created by Jian Chao Man on 3/1/19.
//  Copyright © 2019 Jian Chao Man. All rights reserved.
//

@testable import MangaDot
import XCTest

class MangadexFeedTests: XCTestCase {
    // MARK: - Properties

    // TODO: - Use common protocol later
    var feed: FeedProtocol!

    // MARK: - Set up & Tear Down

    override func setUp() {
        super.setUp()

        // Load Stub
        let data = loadStub(name: "MangadexFeed", extension: "html")

        do {
            try feed = Mangadex.Feed(data: data)
        } catch {
            print(error)
        }
    }

    override func tearDown() {
        super.tearDown()
    }

    // MARK: - Test MangadexFeed properties

    // =======================================
    //
    //            New Section
    //
    // =======================================

    func testNewSectionTitle() {
        XCTAssertEqual(feed.sections[0].titleList[0].title, "Matsurika Kanriden")
    }

    func testNewSectionId() {
        XCTAssertEqual(feed.sections[0].titleList[0].titleId, 33300)
    }

    func testNewSectionCoverUrl() {
        XCTAssertEqual(feed.sections[0].titleList[0].coverUrl.absoluteString,
                       Mangadex.baseUrl.appendingPathComponent("/images/manga/33300.large.jpg").absoluteString)
    }

    func testNewSectionLargeCoverUrl() {
        XCTAssertEqual(feed.sections[0].titleList[0].largeCoverUrl!.absoluteString,
                       Mangadex.baseUrl.appendingPathComponent("/images/manga/33300.jpg").absoluteString)
    }

    // =======================================
    //
    //            Latest Section
    //
    // =======================================

    func testLatestSectionTitle() {
        XCTAssertEqual(feed.sections[1].titleList[0].title, "Rolan the Forgotten King")
    }

    func testLatestSectionId() {
        XCTAssertEqual(feed.sections[1].titleList[0].titleId, 1233)
    }

    func testLatestSectionCoverUrl() {
        XCTAssertEqual(feed.sections[1].titleList[0].coverUrl.absoluteString,
                       Mangadex.baseUrl.appendingPathComponent("/images/manga/1233.large.jpg").absoluteString)
    }

    func testLatestSectionLargeCoverUrl() {
        XCTAssertEqual(feed.sections[1].titleList[0].largeCoverUrl!.absoluteString,
                       Mangadex.baseUrl.appendingPathComponent("/images/manga/1233.jpg").absoluteString)
    }

    // =======================================
    //
    //            Featured Section
    //
    // =======================================

    func testFeaturedSectionTitle() {
        XCTAssertEqual(feed.sections[2].titleList[0].title, "Tensei Shitara Slime Datta Ken")
    }

    func testFeaturedSectionId() {
        XCTAssertEqual(feed.sections[2].titleList[0].titleId, 15553)
    }

    func testFeaturedSectionCoverUrl() {
        XCTAssertEqual(feed.sections[2].titleList[0].coverUrl.absoluteString,
                       Mangadex.baseUrl.appendingPathComponent("/images/manga/15553.large.jpg").absoluteString)
    }

    func testFeaturedSectionLargeCoverUrl() {
        XCTAssertEqual(feed.sections[2].titleList[0].largeCoverUrl!.absoluteString,
                       Mangadex.baseUrl.appendingPathComponent("/images/manga/15553.jpg").absoluteString)
    }

    // =======================================
    //
    //            Top Follows Section
    //
    // =======================================

    func testTopFollowsSectionTitle() {
        XCTAssertEqual(feed.sections[3].titleList[0].title, "Tensei Shitara Slime Datta Ken")
    }

    func testTopFollowsSectionId() {
        XCTAssertEqual(feed.sections[3].titleList[0].titleId, 15553)
    }

    func testTopFollowsSectionCoverUrl() {
        XCTAssertEqual(feed.sections[3].titleList[0].coverUrl.absoluteString,
                       Mangadex.baseUrl.appendingPathComponent("/images/manga/15553.large.jpg").absoluteString)
    }

    func testTopFollowsSectionLargeCoverUrl() {
        XCTAssertEqual(feed.sections[3].titleList[0].largeCoverUrl!.absoluteString,
                       Mangadex.baseUrl.appendingPathComponent("/images/manga/15553.jpg").absoluteString)
    }

    // =======================================
    //
    //            Top Rated Section
    //
    // =======================================

    func testTopRatedSectionTitle() {
        XCTAssertEqual(feed.sections[4].titleList[0].title, "Berserk")
    }

    func testTopRatedSectionId() {
        XCTAssertEqual(feed.sections[4].titleList[0].titleId, 607)
    }

    func testTopRatedSectionCoverUrl() {
        XCTAssertEqual(feed.sections[4].titleList[0].coverUrl.absoluteString,
                       Mangadex.baseUrl.appendingPathComponent("/images/manga/607.large.jpg").absoluteString)
    }

    func testTopRatedSectionLargeCoverUrl() {
        XCTAssertEqual(feed.sections[4].titleList[0].largeCoverUrl!.absoluteString,
                       Mangadex.baseUrl.appendingPathComponent("/images/manga/607.jpg").absoluteString)
    }
}

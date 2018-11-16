//
//  MangadexChapterResponseTests.swift
//  MangaDotTests
//
//  Created by Jian Chao Man on 9/11/18.
//  Copyright © 2018 Jian Chao Man. All rights reserved.
//

@testable import MangaDot
import XCTest

class MangadexChapterResponseTests: XCTestCase {
    // MARK: - Properties

    var mangadexChapterData: ChapterPageData!

    // MARK: - Set up & Tear Down

    override func setUp() {
        super.setUp()

        // Load Stub
        let data = loadStub(name: "mangadexChapter", extension: "json")

        // Initialise JSON Decoder
        let decoder = JSONDecoder()

        // Configure JSON Decoder
        decoder.dateDecodingStrategy = .secondsSince1970
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        // Initialise Mangadex Title Response
        let mangadexChapterResponse = try! decoder.decode(MangadexChapterResponse.self, from: data)

        // Cast as Title Data
        mangadexChapterData = mangadexChapterResponse
    }

    override func tearDown() {
        super.tearDown()
    }

    // MARK: - Mangadex Title Response Tests

    func testCoverUrl() {
        print(mangadexChapterData.pageUrlArray)
    }
}

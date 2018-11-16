//
//  MangadexFeedResponseTests.swift
//  MangaDotTests
//
//  Created by Jian Chao Man on 29/9/18.
//  Copyright © 2018 Jian Chao Man. All rights reserved.
//

@testable import MangaDot
import XCTest

class MangadexFeedResponseTests: XCTestCase {
    // MARK: - Properties

    // TODO: - Use common protocol later
    var mangadexFeedData: MangadexFeedResponse!

    // MARK: - Set up & Tear Down

    override func setUp() {
        super.setUp()

        // Load Stub
        let data = loadStub(name: "mangadexFeed", extension: "html")

        do {
            try mangadexFeedData = MangadexFeedResponse(data: data)
        } catch {
            print(error)
        }
    }

    override func tearDown() {
        super.tearDown()
    }

    // MARK: - Test MangadexFeedResponse propeties

    func testCoverUrl() {
        print(mangadexFeedData)
    }
}

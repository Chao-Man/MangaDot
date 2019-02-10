//
//  MangadexTitleInfoTest.swift
//  MangaDotTests
//
//  Created by Jian Chao Man on 25/1/19.
//  Copyright © 2019 Jian Chao Man. All rights reserved.
//

@testable import MangaDot
import XCTest

class MangadexTitleInfoTests: XCTestCase {
    // MARK: - Properties

    let id = 153
    var titleInfo: TitleInfoProtocol!

    // MARK: - Set up & Tear Down

    override func setUp() {
        super.setUp()

        // Load Stub
        let data = loadStub(name: "MangadexTitleInfo", extension: "json")

        do {
            try titleInfo = Mangadex.TitleInfo(withId: id, data: data)
        } catch {
            print(error)
        }
    }

    override func tearDown() {
        super.tearDown()
    }

    func testTitle() {
        print(titleInfo.title)
    }
}

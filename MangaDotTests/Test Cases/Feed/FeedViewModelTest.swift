//
//  FeedViewModelTests.swift
//  MangaDotTests
//
//  Created by Jian Chao Man on 3/1/19.
//  Copyright © 2019 Jian Chao Man. All rights reserved.
//

@testable import MangaDot
import PromiseKit
import XCTest

class FeedViewModelTests: XCTestCase {
    // MARK: - Properties

    // TODO: - Use common protocol later
    var viewModel: FeedViewModel!
    var source: SourceProtocol!

    // MARK: - Set up & Tear Down

    override func setUp() {
        super.setUp()
        source = Current.sources.mangadex
    }

    override func tearDown() {
        super.tearDown()
    }

    func testNewSectionTitle() {
//        let expect = expectation(description: "")
//
//        viewModel.numberOfSections().done { count in
//            print("1 Num Sections")
//            print(count)
//            XCTAssert(true)
//            expect.fulfill()
//        }
//
//        waitForExpectations(timeout: 5) { (error) in
//            if let error = error {
//                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
//            }
//        }
        print(source.typeName())
    }

//    func testNewSectionTitle2() {
//        let expect = expectation(description: "")
//
//        viewModel.numberOfSections().done { count in
//            print("2 Num Sections")
//            print(count)
//            XCTAssert(true)
//            expect.fulfill()
//        }
//
//        waitForExpectations(timeout: 5) { (error) in
//            if let error = error {
//                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
//            }
//        }
//    }
//
//    func testNewSectionTitle3() {
//        let expect = expectation(description: "")
//
//        viewModel.numberOfSections().done { count in
//            print("3 Num Sections")
//            print(count)
//            XCTAssert(true)
//            expect.fulfill()
//        }
//
//        waitForExpectations(timeout: 5) { (error) in
//            if let error = error {
//                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
//            }
//        }
//    }
//
//    func testNewSectionTitle4() {
//        let expect = expectation(description: "")
//
//        viewModel.numberOfSections().done { count in
//            print("4 Num Sections")
//            print(count)
//            XCTAssert(true)
//            expect.fulfill()
//        }
//
//        waitForExpectations(timeout: 5) { (error) in
//            if let error = error {
//                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
//            }
//        }
//    }
}

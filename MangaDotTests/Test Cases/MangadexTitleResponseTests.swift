//
//  TitleViewModelTests.swift
//  MangaDotTests
//
//  Created by Jian Chao Man on 29/9/18.
//  Copyright © 2018 Jian Chao Man. All rights reserved.
//

@testable import MangaDot
import XCTest

class MangadexTitleResponseTests: XCTestCase {
    // MARK: - Properties

    var mangadexTitleData: DetailedTitleData!

    // MARK: - Set up & Tear Down

    override func setUp() {
        super.setUp()

        // Load Stub
        let data = loadStub(name: "mangadexTitle", extension: "json")

        // Initialise JSON Decoder
        let decoder = JSONDecoder()

        // Configure JSON Decoder
        decoder.dateDecodingStrategy = .secondsSince1970
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        // Initialise Mangadex Title Response
        let mangadexTitleResponse = try! decoder.decode(MangadexTitleResponse.self, from: data)

        // Cast as Title Data
        mangadexTitleData = mangadexTitleResponse
    }

    override func tearDown() {
        super.tearDown()
    }

    // MARK: - Mangadex Title Response Tests

    func testCoverUrl() {
        XCTAssertEqual(mangadexTitleData.coverUrl.absoluteString.removingPercentEncoding!, "https://mangadex.org/images/manga/153.large.jpg?1528849721")
    }

    func testMangadexTitle() {
        XCTAssertEqual(mangadexTitleData.title, "Detective Conan")
    }

    func testDescription() {
        XCTAssertEqual(mangadexTitleData.description, "Shinichi Kudo is a high school detective who sometimes works with the police to solve cases. During an investigation, he is attacked by members of a crime syndicate known as the Black Organization. They force him to ingest an experimental poison, but instead of killing him, the poison transforms him into a child. Adopting the pseudonym Conan Edogawa and keeping his true identity a secret, Kudo lives with his childhood friend Ran and her father Kogoro, who is a private detective.")
    }

    func testArtist() {
        XCTAssertEqual(mangadexTitleData.artist, "Aoyama Gosho")
    }

    func testAuthor() {
        XCTAssertEqual(mangadexTitleData.author, "Aoyama Gosho")
    }

    func testStatus() {
        XCTAssertEqual(mangadexTitleData.status, 1)
    }

    func testGenres() {
        let genres: [Int8] = [2, 3, 4, 5, 8, 20, 22, 23, 24, 35]
        XCTAssertEqual(mangadexTitleData.genres, genres)
    }

    func testLastChapter() {
        XCTAssertEqual(mangadexTitleData.lastChapter, "0")
    }

    func testLangName() {
        XCTAssertEqual(mangadexTitleData.langName, "Japanese")
    }

    func testLangFlag() {
        XCTAssertEqual(mangadexTitleData.langFlag, "jp")
    }

    func testAscOrderedChapterId() {
        XCTAssertEqual(mangadexTitleData.chapters(withLanguage: "gb", orderBy: .ascending).first!.id, 447_126)
    }
}

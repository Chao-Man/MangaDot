//
//  XCTest.swift
//  MangaTests
//
//  Created by Jian Chao Man on 27/9/18.
//  Copyright © 2018 Jian Chao Man. All rights reserved.
//

import XCTest

extension XCTest {
    func loadStub(name: String, extension: String) -> Data {
        let bundle = Bundle(for: classForCoder)
        let url = bundle.url(forResource: name, withExtension: `extension`)

        return try! Data(contentsOf: url!)
    }
}

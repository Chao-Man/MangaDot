//
//  SectionProtocol.swift
//  MangaDot
//
//  Created by Jian Chao Man on 2/1/19.
//  Copyright © 2019 Jian Chao Man. All rights reserved.
//

import Foundation

public protocol SectionProtocol {
    var sectionName: String { get }
    var titleList: [BasicTitleProtocol] { get }
}

extension SectionProtocol {
    func isEmpty() -> Bool {
        return titleList.count < 1
    }
}

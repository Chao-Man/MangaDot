//
//  BasicTitleProtocol.swift
//  MangaDot
//
//  Created by Jian Chao Man on 2/1/19.
//  Copyright © 2019 Jian Chao Man. All rights reserved.
//

import Foundation

public protocol BasicTitleProtocol {
    var titleId: Int { get }
    var coverUrl: URL { get }
    var largeCoverUrl: URL? { get }
    var title: String { get }
}

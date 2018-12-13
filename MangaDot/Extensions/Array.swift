//
//  Array.swift
//  MangaDot
//
//  Created by Jian Chao Man on 13/12/18.
//  Copyright © 2018 Jian Chao Man. All rights reserved.
//

import Foundation

extension Array where Element: Hashable {
    func next(item: Element) -> Element? {
        if let index = self.index(of: item), index + 1 <= self.count {
            return index + 1 == count ? self[0] : self[index + 1]
        }
        return nil
    }

    func prev(item: Element) -> Element? {
        if let index = self.index(of: item), index >= 0 {
            return index == 0 ? last : self[index - 1]
        }
        return nil
    }
}

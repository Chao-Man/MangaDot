//
//  String.swift
//  MangaDot
//
//  Created by Jian Chao Man on 1/10/18.
//  Copyright © 2018 Jian Chao Man. All rights reserved.
//

import Foundation

extension String {
    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }

    func localizedFormatString(args: String...) -> String {
        return String(format: localized(), args)
    }
}

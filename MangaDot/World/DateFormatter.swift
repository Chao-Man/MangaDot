//
//  DateFormatter.swift
//  MangaDot
//
//  Created by Jian Chao Man on 24/1/19.
//  Copyright © 2019 Jian Chao Man. All rights reserved.
//

import Foundation

extension World {
    func dateFormatter(
        dateStyle: DateFormatter.Style = .none,
        timeStyle: DateFormatter.Style = .none
    )
        -> DateFormatter {
        let formatter = DateFormatter()

        formatter.dateStyle = dateStyle
        formatter.timeStyle = timeStyle

        formatter.calendar = calendar
        formatter.locale = locale
        formatter.timeZone = timeZone

        return formatter
    }
}

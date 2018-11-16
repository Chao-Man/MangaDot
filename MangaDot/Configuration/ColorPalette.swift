//
//  Palette.swift
//  MangaDot
//
//  Created by Jian Chao Man on 15/11/18.
//  Copyright © 2018 Jian Chao Man. All rights reserved.
//

import UIKit

struct ColorPalette {
    let colors: UIImageColors
    let barTintColor: UIColor?
    let tintColor: UIColor?
    let barStyle: UIBarStyle
    let titleTextAttributes: [NSAttributedString.Key: Any]?
    let separatorColor: UIColor?

    init(colors: UIImageColors) {
        self.colors = colors
        switch colors.background {
        case UIColor.white:
            barTintColor = nil
            tintColor = nil
            barStyle = .default
            separatorColor = nil
            titleTextAttributes = [
                NSAttributedString.Key.foregroundColor: colors.primary,
            ]
        case UIColor.black:
            barTintColor = nil
            tintColor = nil
            barStyle = .blackTranslucent
            separatorColor = nil
            titleTextAttributes = [
                NSAttributedString.Key.foregroundColor: colors.primary,
            ]
        default:
            barTintColor = colors.background
            tintColor = colors.primary
            barStyle = colors.background.barStyle
            separatorColor = colors.primary.withAlphaComponent(0.2)
            titleTextAttributes = [
                NSAttributedString.Key.foregroundColor: colors.primary,
            ]
        }
    }
}

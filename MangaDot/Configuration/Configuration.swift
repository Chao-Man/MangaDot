//
//  Configuration.swift
//  MangaDot
//
//  Created by Jian Chao Man on 1/10/18.
//  Copyright © 2018 Jian Chao Man. All rights reserved.
//

import UIKit

struct MangaDot {
    struct Tabs {
        struct Strings {
            let readnow = "Read Now"
            let library = "Library"
            let search = "Search"
            let settings = "Settings"
        }
    }

    enum Shadow {
        static let dropShadow = ShadowOptions(color: .black, alpha: 0.2, x: 0, y: 1, blur: 5, spread: 0)
    }

    enum Pallete {
        private static let lightImageColors = UIImageColors(background: .white, primary: .black, secondary: UIColor.MangaDot.lightGray, detail: .lightGray)
        static let lightTheme = ColorPalette(colors: lightImageColors)
    }
}

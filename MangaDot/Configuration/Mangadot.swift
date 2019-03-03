//
//  MangaDot.swift
//  MangaDot
//
//  Created by Jian Chao Man on 7/1/19.
//  Copyright © 2019 Jian Chao Man. All rights reserved.
//

import SwiftHEXColors
import UIKit

struct MangaDot {
    struct Font {
        static let heavyHuge: UIFont = .systemFont(ofSize: 40, weight: .heavy)
        static let heavyLarge: UIFont = .systemFont(ofSize: 23.0, weight: .heavy)
        static let heavyNormal: UIFont = .systemFont(ofSize: 17.0, weight: .heavy)
        static let heavySmall: UIFont = .systemFont(ofSize: 15.0, weight: .heavy)
        static let heavySmaller: UIFont = .systemFont(ofSize: 13, weight: .heavy)
        static let heavyTiny: UIFont = .systemFont(ofSize: 11.0, weight: .heavy)
        static let heavyTinier: UIFont = .systemFont(ofSize: 7.0, weight: .heavy)

        static let boldHuge: UIFont = .systemFont(ofSize: 40, weight: .bold)
        static let boldLarge: UIFont = .systemFont(ofSize: 23.0, weight: .bold)
        static let boldNormal: UIFont = .systemFont(ofSize: 17.0, weight: .bold)
        static let boldSmall: UIFont = .systemFont(ofSize: 15.0, weight: .bold)
        static let boldSmaller: UIFont = .systemFont(ofSize: 13, weight: .bold)
        static let boldTiny: UIFont = .systemFont(ofSize: 11.0, weight: .bold)
        static let boldTinier: UIFont = .systemFont(ofSize: 7.0, weight: .bold)

        static let mediumHuge: UIFont = .systemFont(ofSize: 40, weight: .medium)
        static let mediumLarge: UIFont = .systemFont(ofSize: 23.0, weight: .medium)
        static let mediumNormal: UIFont = .systemFont(ofSize: 17.0, weight: .medium)
        static let mediumSmall: UIFont = .systemFont(ofSize: 15.0, weight: .medium)
        static let mediumSmaller: UIFont = .systemFont(ofSize: 13, weight: .medium)
        static let mediumTiny: UIFont = .systemFont(ofSize: 11.0, weight: .medium)
        static let mediumTinier: UIFont = .systemFont(ofSize: 7.0, weight: .medium)

        static let regularHuge: UIFont = .systemFont(ofSize: 40, weight: .regular)
        static let regularLarge: UIFont = .systemFont(ofSize: 23.0, weight: .regular)
        static let regularNormal: UIFont = .systemFont(ofSize: 17.0, weight: .regular)
        static let regularSmall: UIFont = .systemFont(ofSize: 15.0, weight: .regular)
        static let regularSmaller: UIFont = .systemFont(ofSize: 13, weight: .regular)
        static let regularTiny: UIFont = .systemFont(ofSize: 11.0, weight: .regular)
        static let regularTinier: UIFont = .systemFont(ofSize: 7.0, weight: .regular)

        static let lightHuge: UIFont = .systemFont(ofSize: 40, weight: .light)
        static let lightLarge: UIFont = .systemFont(ofSize: 23.0, weight: .light)
        static let lightNormal: UIFont = .systemFont(ofSize: 17.0, weight: .light)
        static let lightSmall: UIFont = .systemFont(ofSize: 15.0, weight: .light)
        static let lightSmaller: UIFont = .systemFont(ofSize: 13, weight: .light)
        static let lightTiny: UIFont = .systemFont(ofSize: 11.0, weight: .light)
        static let lightTinier: UIFont = .systemFont(ofSize: 7.0, weight: .light)
    }

    struct Color {
        static let lightGray = UIColor(white: 0.8, alpha: 1.0)
        static let gray = UIColor.gray
        static let black = UIColor.black
        static let darkGray = UIColor.darkGray
        static let pink = UIColor(hexString: "#FF135A")!
        static let purple = UIColor(hexString: "#AF2EE3")!
        static let white = UIColor.white
        static let veryWhiteGray = UIColor(hexString: "#F9F9F9")!
        static let whiteGray = UIColor(hexString: "#F2F2F2")!
    }

    struct Shadow {
        static let coverViewShadow = ShadowOptions(color: .black, alpha: 0.2, x: 0, y: 1, blur: 5, spread: 0, cornerRadius: CornerRadius.coverView)
        static let defaultShadow =  ShadowOptions(color: .black, alpha: 0.2, x: 0, y: 1, blur: 5, spread: 0, cornerRadius: 0)
    }
    
    struct CornerRadius {
        static let coverView: CGFloat = 8.0
        static let buttons: CGFloat = 10.0
    }
}

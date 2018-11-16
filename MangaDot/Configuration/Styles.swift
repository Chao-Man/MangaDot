//
//  Styles.swift
//  MangaDot
//
//  Created by Jian Chao Man on 3/10/18.
//  Copyright © 2018 Jian Chao Man. All rights reserved.
//

import UIKit

extension UIColor {
    enum MangaDot {
        static let lightGray = UIColor(white: 0.8, alpha: 1.0)
    }
}

extension UIFont {
    enum MangaDot {
        static let heavyLarge: UIFont = .systemFont(ofSize: 23.0, weight: .heavy)
        static let heavyNormal: UIFont = .systemFont(ofSize: 17.0, weight: .heavy)
        static let heavySmall: UIFont = .systemFont(ofSize: 15.0, weight: .heavy)
        static let heavySmaller: UIFont = .systemFont(ofSize: 13, weight: .heavy)
        static let heavyTiny: UIFont = .systemFont(ofSize: 11.0, weight: .heavy)

        static let boldLarge: UIFont = .systemFont(ofSize: 23.0, weight: .bold)
        static let boldNormal: UIFont = .systemFont(ofSize: 17.0, weight: .bold)
        static let boldSmall: UIFont = .systemFont(ofSize: 15.0, weight: .bold)
        static let boldSmaller: UIFont = .systemFont(ofSize: 13, weight: .bold)
        static let boldTiny: UIFont = .systemFont(ofSize: 11.0, weight: .bold)

        static let mediumLarge: UIFont = .systemFont(ofSize: 23.0, weight: .medium)
        static let mediumNormal: UIFont = .systemFont(ofSize: 17.0, weight: .medium)
        static let mediumSmall: UIFont = .systemFont(ofSize: 15.0, weight: .medium)
        static let mediumSmaller: UIFont = .systemFont(ofSize: 13, weight: .medium)
        static let mediumTiny: UIFont = .systemFont(ofSize: 11.0, weight: .medium)

        static let regularLarge: UIFont = .systemFont(ofSize: 23.0, weight: .regular)
        static let regularNormal: UIFont = .systemFont(ofSize: 17.0, weight: .regular)
        static let regularSmall: UIFont = .systemFont(ofSize: 15.0, weight: .regular)
        static let regularSmaller: UIFont = .systemFont(ofSize: 13, weight: .regular)
        static let regularTiny: UIFont = .systemFont(ofSize: 11.0, weight: .regular)

        static let lightLarge: UIFont = .systemFont(ofSize: 23.0, weight: .light)
        static let lightNormal: UIFont = .systemFont(ofSize: 17.0, weight: .light)
        static let lightSmall: UIFont = .systemFont(ofSize: 15.0, weight: .light)
        static let lightSmaller: UIFont = .systemFont(ofSize: 13, weight: .light)
        static let lightTiny: UIFont = .systemFont(ofSize: 11.0, weight: .light)
    }
}

extension CALayer {
    func applyShadow(options: ShadowOptions) {
        shadowColor = options.color.cgColor
        shadowOpacity = options.alpha
        shadowOffset = CGSize(width: options.x, height: options.y)
        shadowRadius = options.blur / 2.0
        masksToBounds = false
        if options.spread == 0 {
            shadowPath = nil
        } else {
            let dx = -options.spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).cgPath
        }
    }
}

struct ShadowOptions {
    let color: UIColor
    let alpha: Float
    let x: CGFloat
    let y: CGFloat
    let blur: CGFloat
    let spread: CGFloat
}

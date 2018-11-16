//
//  UserDefaults.swift
//  MangaDot
//
//  Created by Jian Chao Man on 15/11/18.
//  Copyright © 2018 Jian Chao Man. All rights reserved.
//

import UIKit

extension UserDefaults {
    // MARK: - Types

    private enum Keys {
        static let palette = "palette"
        static let backgroundColor = "backgroundColor"
        static let primaryColor = "primaryColor"
        static let secondaryColor = "secondaryColor"
        static let detailColor = "detailColor"
    }

    // MARK: - Class Computed Properties

    static var palette = MangaDot.Pallete.lightTheme

//    class var palette: ColorPalette? {
//        get {
    //////            return UserDefaults.standard.object(forKey: Keys.palette) as? ColorPalette
    ////            let background = colorForKey(Keys.backgroundColor)
    ////            let primary = colorForKey(Keys.primaryColor)
    ////            let secondary = colorForKey(Keys.secondaryColor)
    ////            let detail = colorForKey(Keys.detailColor)
    ////
    ////            let colors = UIImageColors(background: background, primary: primary, secondary: secondary, detail: detail)
    ////            return ColorPalette(colors: colors)
//            if let paletteData = UserDefaults.standard.data(forKey: Keys.palette) {
//                return NSKeyedUnarchiver.unarchiveObject(with: paletteData) as? ColorPalette
//            } else {
//                return nil
//            }
//        }
//        set(newValue) {
//            if let newValue = newValue {
//                var paletteData: NSData?
//                paletteData = NSKeyedArchiver.archivedData(withRootObject: newValue) as NSData?
//                UserDefaults.standard.set(paletteData, forKey: Keys.palette)
//            }
    ////            set(paletteData, forkey: Keys.palette)
//        }
//    }

    func colorForKey(key: String) -> UIColor? {
        var color: UIColor?
        if let colorData = data(forKey: key) {
            color = NSKeyedUnarchiver.unarchiveObject(with: colorData) as? UIColor
        }
        return color
    }

    func setColor(color: UIColor?, forKey key: String) {
        var colorData: NSData?
        if let color = color {
            colorData = NSKeyedArchiver.archivedData(withRootObject: color) as NSData?
        }
        set(colorData, forKey: key)
    }
}

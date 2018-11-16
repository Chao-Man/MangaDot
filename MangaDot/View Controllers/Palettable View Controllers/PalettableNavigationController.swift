//
//  PalatableNavigationController.swift
//  MangaDot
//
//  Created by Jian Chao Man on 15/11/18.
//  Copyright © 2018 Jian Chao Man. All rights reserved.
//

import UIKit

class PalettableNavigationController: UINavigationController, Palettable {
    var palette: ColorPalette = MangaDot.Pallete.lightTheme {
        didSet {
            applyPalette(palette: palette)
        }
    }

    override init(navigationBarClass: AnyClass?, toolbarClass: AnyClass?) {
        super.init(navigationBarClass: navigationBarClass, toolbarClass: toolbarClass)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func applyPalette(palette: ColorPalette) {
        UIView.animate(withDuration: 0.2) {
            self.navigationBar.titleTextAttributes = palette.titleTextAttributes
            self.navigationBar.barTintColor = palette.barTintColor
            self.navigationBar.tintColor = palette.tintColor
            self.navigationBar.barStyle = palette.barStyle
            self.navigationBar.layoutIfNeeded()
        }
    }
}

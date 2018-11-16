//
//  PalatableViewController.swift
//  MangaDot
//
//  Created by Jian Chao Man on 15/11/18.
//  Copyright © 2018 Jian Chao Man. All rights reserved.
//

import UIKit

class PalettableViewController: UIViewController, Palettable {
    var palette: ColorPalette = MangaDot.Pallete.lightTheme {
        didSet {
            applyPalette(palette: palette)
        }
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    func applyPalette(palette: ColorPalette) {
        UIView.animate(withDuration: 0.2) {
            self.view.backgroundColor = palette.colors.background
        }
    }
}

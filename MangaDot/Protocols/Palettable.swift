//
//  Palatable.swift
//  MangaDot
//
//  Created by Jian Chao Man on 15/11/18.
//  Copyright © 2018 Jian Chao Man. All rights reserved.
//

import UIKit

protocol Palettable {
    var palette: ColorPalette { get set }

    func applyPalette(palette: ColorPalette)
}

//
//  DropShadowView.swift
//  MangaDot
//
//  Created by Jian Chao Man on 3/11/18.
//  Copyright © 2018 Jian Chao Man. All rights reserved.
//

import UIKit

class DropShadowView: UIView {
    var options: ShadowOptions = MangaDot.Shadow.dropShadow

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    override func layoutSubviews() {
        layer.applyShadow(options: options)
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
}

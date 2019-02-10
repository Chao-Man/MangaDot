//
//  DropShadowView.swift
//  MangaDot
//
//  Created by Jian Chao Man on 9/1/19.
//  Copyright © 2019 Jian Chao Man. All rights reserved.
//

import UIKit

class DropShadowView: UIView {
    var options: ShadowOptions

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }

    init(frame: CGRect, shadowOptions: ShadowOptions = MangaDot.Shadow.defaultShadow) {
        self.options = shadowOptions
        super.init(frame: frame)
    }

    override func layoutSubviews() {
        layer.applyShadow(options: options, path: nil)
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        super.layoutSubviews()
    }
}

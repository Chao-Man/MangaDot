//
//  SeperatorView.swift
//  MangaDot
//
//  Created by Jian Chao Man on 3/11/18.
//  Copyright © 2018 Jian Chao Man. All rights reserved.
//

import UIKit

enum SeparatorAxis {
    case vertical
    case horizontal
}

class SeparatorView: UIView {
    let axis: SeparatorAxis
    let width: CGFloat
    let inset: CGFloat
    let color: UIColor

    init(axis: SeparatorAxis, inset: CGFloat = 0, width: CGFloat = 0.5, color: UIColor = MangaDot.Color.lightGray) {
        self.axis = axis
        self.width = width
        self.inset = inset
        self.color = color
        super.init(frame: CGRect.zero)
        backgroundColor = UIColor.clear
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        var lineRect: CGRect
        switch axis {
        case .horizontal:
            lineRect = CGRect(
                x: rect.minX + inset,
                y: rect.midY - width,
                width: rect.width - (inset * 2),
                height: width
            )
        case .vertical:
            lineRect = CGRect(
                x: rect.midX - width,
                y: rect.minY + inset,
                width: width,
                height: rect.height - (inset * 2)
            )
        }

        let path = UIBezierPath(rect: lineRect)
        color.setFill()
        path.fill()
    }

    override func layoutSubviews() {
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
}

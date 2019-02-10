//
//  CALayer.swift
//  MangaDot
//
//  Created by Jian Chao Man on 9/1/19.
//  Copyright © 2019 Jian Chao Man. All rights reserved.
//

import UIKit

extension CALayer {
    func applyShadow(options: ShadowOptions, path: CGPath?) {
        shadowColor = options.color.cgColor
        shadowOpacity = options.alpha
        shadowOffset = CGSize(width: options.x, height: options.y)
        shadowRadius = options.blur / 2.0
        cornerRadius = options.cornerRadius
        masksToBounds = false
        let dx = -options.spread
        let rect = bounds.insetBy(dx: dx, dy: dx)

        if path == nil {
            shadowPath = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).cgPath
        } else {
            shadowPath = path
        }
    }

    func applyMask(with path: CGPath?) {
        let newMask = CAShapeLayer()
        newMask.path = path
        mask = newMask
    }
}

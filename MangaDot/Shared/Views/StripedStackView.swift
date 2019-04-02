//
//  StripedStackView.swift
//  MangaDot
//
//  Created by Jian Chao Man on 3/11/18.
//  Copyright © 2018 Jian Chao Man. All rights reserved.
//

import UIKit
import Yalta

class StripedStackView: UIStackView {
    private var stripedViews: [(UIView, CAGradientLayer)] = []

    override func addArrangedSubview(_ view: UIView) {
        if arrangedSubviews.count % 2 != 0 {
            let gradientLayer = CAGradientLayer()
            gradientLayer.locations = [0.0, 0.02, 0.98, 1.0]
            gradientLayer.colors = [MangaDot.Color.whiteGray.cgColor, MangaDot.Color.veryWhiteGray.cgColor, MangaDot.Color.veryWhiteGray.cgColor, MangaDot.Color.whiteGray.cgColor]
            view.layer.insertSublayer(gradientLayer, at: 0)
            stripedViews.append((view, gradientLayer))
        }

        super.addArrangedSubview(view)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        stripedViews.forEach { $0.1.frame = $0.0.bounds }
    }
}

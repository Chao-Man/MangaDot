//
//  GradientTableView.swift
//  MangaDot
//
//  Created by Jian Chao Man on 14/1/19.
//  Copyright © 2019 Jian Chao Man. All rights reserved.
//

import UIKit

class GradientTableView: UITableView {
    private let gradientLayer = CAGradientLayer()

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setupGradient()
    }

    private func setupGradient() {
        backgroundView = UIView()
        gradientLayer.locations = [0.0, 0.02]
        gradientLayer.colors = [MangaDot.Color.whiteGray.cgColor, MangaDot.Color.veryWhiteGray.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        backgroundView!.layer.insertSublayer(gradientLayer, at: 0)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = backgroundView!.frame
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

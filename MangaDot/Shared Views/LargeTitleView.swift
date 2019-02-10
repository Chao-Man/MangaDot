//
//  LargeTitleView.swift
//  MangaDot
//
//  Created by Jian Chao Man on 24/1/19.
//  Copyright © 2019 Jian Chao Man. All rights reserved.
//

import UIKit
import Yalta

class LargeTitleView: UIView {
    // MARK: Computed Instance Properties

    lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = MangaDot.Font.boldSmaller
        label.textColor = MangaDot.Color.gray
        return label
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = MangaDot.Font.boldHuge
        label.textColor = UIColor.black
        return label
    }()

    private var inset: CGFloat

    // MARK: - Life Cycle

    init(inset: CGFloat = 45) {
        self.inset = inset
        super.init(frame: CGRect.zero)
        addViews()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.sizeToFit()
        subtitleLabel.sizeToFit()
    }

    // MARK: - Helper Methods

    private func addViews() {
        addSubview(subtitleLabel, titleLabel) { subtitleLabel, titleLabel in
            subtitleLabel.top.pinToSuperview(inset: 30, relation: .equal)
            subtitleLabel.edges(.left, .right).pinToSuperview(insets: Inset(inset), relation: .equal)
            titleLabel.bottom.pinToSuperview(inset: 5, relation: .equal)
            titleLabel.edges(.left, .right).pinToSuperview(insets: Inset(inset), relation: .equal)
            titleLabel.top.align(with: subtitleLabel.bottom + 5)
        }
    }
}

//
//  CarouselCell.swift
//  MangaDot
//
//  Created by Jian Chao Man on 7/1/19.
//  Copyright © 2019 Jian Chao Man. All rights reserved.
//

import UIKit
import Yalta

class CarouselCell: UICollectionViewCell {
    // MARK: - Instance Properties
    private let coverViewInset: CGFloat = 5
    
    // MARK: - Computed Instance Properties

    lazy var titleLabel: UILabel = {
        let titleView = UILabel()
        titleView.font = MangaDot.Font.regularSmaller
        titleView.textColor = MangaDot.Color.darkGray
        titleView.lineBreakMode = .byWordWrapping
        titleView.numberOfLines = 2
        return titleView
    }()

    lazy var coverView = ShadowCoverView()

    // MARK: - Life Cycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.sizeToFit()
    }

    // MARK: - Helper Methods

    private func addViews() {
        addSubview(coverView, titleLabel) { coverView, titleView in
            coverView.top.pinToSuperviewMargin(inset: coverViewInset, relation: .equal)
            coverView.left.pinToSuperviewMargin(inset: coverViewInset, relation: .equal)
            coverView.height.match((al.height - (coverViewInset * 2)) * 0.75)
            coverView.width.match(coverView.height * 0.703349282)
            titleView.top.align(with: coverView.bottom + coverViewInset)
            titleView.edges(.left, .right).pinToSuperviewMargins(insets: Inset(coverViewInset), relation: .equal)
            titleView.bottom.pinToSuperviewMargin()
        }
    }
}

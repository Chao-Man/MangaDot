//
//  FlipBoardView.swift
//  MangaDot
//
//  Created by Jian Chao Man on 9/2/19.
//  Copyright © 2019 Jian Chao Man. All rights reserved.
//

import UIKit
import Yalta

class FlipBoardView: UIView {
    // MARK: - Instance Properties
    
    var labelColor = MangaDot.Color.white {
        didSet {
            titleLabel.textColor = labelColor
            numberLabel.textColor = labelColor
        }
    }
    
    private var topBottomInset: CGFloat = 5
    
    // MARK: - Computed Instance Properties
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = MangaDot.Font.boldTinier
        label.textAlignment = .center
        return label
    }()
    
    lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.font = MangaDot.Font.boldLarge
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper Methods
    
    private func setupView() {
        addViews()
        clipsToBounds = true
    }
    
    private func addViews() {
        addSubview(titleLabel, numberLabel) {
            $0.top.pinToSuperview(inset: topBottomInset)
            $0.edges(.left, .right).pinToSuperview()
            $0.height.match((al.height - topBottomInset) * (1/6))
            $1.edges(.left, .right).pinToSuperview()
            $1.bottom.pinToSuperview(inset: topBottomInset)
            $1.top.align(with: $0.bottom)
        }
    }
}
